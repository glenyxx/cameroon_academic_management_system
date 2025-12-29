import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '/data/models/user_model.dart';

class AIService {
  static const String _baseUrl = AppConstants.geminiApiUrl;
  static const String _apiKey = AppConstants.geminiApiKey;

  // GENERATE STUDY RECOMMENDATIONS
  Future<Map<String, dynamic>> generateStudyRecommendations({
    required UserModel user,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      final prompt = '''
You are an AI educational assistant for Cameroonian students.

Student Profile:
- Name: ${user.name}
- Class: ${user.className}
- Subjects: ${user.subjects.join(', ')}
- Language: ${user.language == 'en' ? 'English' : 'French'}

Recent Progress:
${_formatProgressData(progressData)}

Based on this student's profile and progress, provide:
1. Three personalized study recommendations
2. Topics that need attention
3. Subjects where they're excelling
4. Motivational message

Respond in ${user.language == 'en' ? 'English' : 'French'} in JSON format:
{
  "recommendations": [
    {"title": "...", "description": "...", "priority": "high/medium/low"}
  ],
  "needsAttention": ["topic1", "topic2"],
  "excelling": ["subject1", "subject2"],
  "motivationalMessage": "..."
}
''';

      final response = await _callGemini(prompt);
      return _parseJsonResponse(response);
    } catch (e) {
      throw 'Failed to generate recommendations: $e';
    }
  }

  // EXPLAIN CONCEPT (FOR STRUGGLING TOPICS)
  Future<String> explainConcept({
    required String subject,
    required String topic,
    required String language,
    String? specificQuestion,
  }) async {
    try {
      final prompt = '''
You are teaching ${language == 'en' ? 'an English' : 'a French'}-speaking Cameroonian secondary school student.

Subject: $subject
Topic: $topic
${specificQuestion != null ? 'Specific Question: $specificQuestion' : ''}

Provide a clear, simple explanation suitable for secondary school level.
Use examples relevant to Cameroon where appropriate.
Keep the explanation under 200 words.

Respond in ${language == 'en' ? 'English' : 'French'}.
''';

      return await _callGemini(prompt);
    } catch (e) {
      throw 'Failed to explain concept: $e';
    }
  }

  // GENERATE PRACTICE QUESTIONS
  Future<List<Map<String, dynamic>>> generatePracticeQuestions({
    required String subject,
    required String topic,
    required String level, // 'O-Level', 'A-Level', etc.
    int count = 5,
  }) async {
    try {
      final prompt = '''
Generate $count multiple choice practice questions for:
- Subject: $subject
- Topic: $topic
- Level: $level (Cameroon GCE system)

Format each question as JSON:
{
  "question": "...",
  "options": ["A", "B", "C", "D"],
  "correctAnswer": "A",
  "explanation": "..."
}

Return an array of questions in JSON format.
''';

      final response = await _callGemini(prompt);
      final parsed = _parseJsonResponse(response);
      return List<Map<String, dynamic>>.from(parsed['questions'] ?? []);
    } catch (e) {
      throw 'Failed to generate questions: $e';
    }
  }

  // ANALYZE EXAM PERFORMANCE
  Future<Map<String, dynamic>> analyzeExamPerformance({
    required List<Map<String, dynamic>> examResults,
    required String subject,
  }) async {
    try {
      final prompt = '''
Analyze this student's exam performance:

Subject: $subject
Results:
${_formatExamResults(examResults)}

Provide analysis in JSON format:
{
  "strengths": ["topic1", "topic2"],
  "weaknesses": ["topic1", "topic2"],
  "improvementSuggestions": [
    {"area": "...", "suggestion": "...", "priority": "high/medium/low"}
  ],
  "overallAssessment": "...",
  "nextSteps": ["step1", "step2"]
}
''';

      final response = await _callGemini(prompt);
      return _parseJsonResponse(response);
    } catch (e) {
      throw 'Failed to analyze performance: $e';
    }
  }

  // MATCH SCHOLARSHIPS
  Future<List<Map<String, dynamic>>> matchScholarships({
    required UserModel user,
    required List<Map<String, dynamic>> availableScholarships,
  }) async {
    try {
      final prompt = '''
Match scholarships for this student:

Student Profile:
- Subjects: ${user.subjects.join(', ')}
- Class Level: ${user.className}
- Location: Cameroon

Available Scholarships:
${_formatScholarships(availableScholarships)}

Return matched scholarships with match percentage in JSON:
[
  {
    "scholarshipId": "...",
    "matchPercentage": 85,
    "matchReasons": ["reason1", "reason2"]
  }
]
''';

      final response = await _callGemini(prompt);
      final parsed = _parseJsonResponse(response);
      return List<Map<String, dynamic>>.from((parsed as List).map((e) => Map<String, dynamic>.from(e)),
    );
    } catch (e) {
      throw 'Failed to match scholarships: $e';
    }
  }

  // SUGGEST STUDY SCHEDULE
  Future<Map<String, dynamic>> suggestStudySchedule({
    required List<String> subjects,
    required DateTime examDate,
    required int availableHoursPerDay,
  }) async {
    try {
      final daysUntilExam = examDate.difference(DateTime.now()).inDays;

      final prompt = '''
Create a study schedule for:
- Subjects: ${subjects.join(', ')}
- Days until exam: $daysUntilExam
- Available study hours per day: $availableHoursPerDay

Provide a balanced schedule in JSON format:
{
  "weeklySchedule": {
    "Monday": [{"subject": "...", "hours": 2, "topics": ["...", "..."]}],
    "Tuesday": [...],
    ...
  },
  "tips": ["tip1", "tip2"],
  "milestones": [
    {"week": 1, "goal": "..."},
    {"week": 2, "goal": "..."}
  ]
}
''';

      final response = await _callGemini(prompt);
      return _parseJsonResponse(response);
    } catch (e) {
      throw 'Failed to generate schedule: $e';
    }
  }

  // GENERATE MOTIVATIONAL MESSAGE
  Future<String> generateMotivation({
    required String studentName,
    required int studyStreak,
    required String language,
  }) async {
    try {
      final prompt = '''
Generate a short motivational message for $studentName.
They have a study streak of $studyStreak days.
Keep it encouraging and specific to their progress.
Max 50 words.
Language: ${language == 'en' ? 'English' : 'French'}
''';

      return await _callGemini(prompt);
    } catch (e) {
      return language == 'en'
          ? "Keep up the great work! You're doing amazing!"
          : "Continue comme ça! Tu fais un excellent travail!";
    }
  }

  // CORE GEMINI API CALL
  Future<String> _callGemini(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1024,
          }
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        throw 'API Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      throw 'Gemini API call failed: $e';
    }
  }

  // PARSE JSON RESPONSE FROM GEMINI
  Map<String, dynamic> _parseJsonResponse(String response) {
    try {
      // Remove markdown code blocks if present
      String cleaned = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleaned);
    } catch (e) {
      throw 'Failed to parse AI response: $e';
    }
  }

  // HELPER: FORMAT PROGRESS DATA
  String _formatProgressData(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '- ${e.key}: ${e.value}')
        .join('\n');
  }

  // HELPER: FORMAT EXAM RESULTS
  String _formatExamResults(List<Map<String, dynamic>> results) {
    return results
        .map((r) => '- ${r['topic']}: ${r['score']}%')
        .join('\n');
  }

  // HELPER: FORMAT SCHOLARSHIPS
  String _formatScholarships(List<Map<String, dynamic>> scholarships) {
    return scholarships
        .map((s) => '- ${s['title']}: ${s['field']} (${s['level']})')
        .join('\n');
  }
}