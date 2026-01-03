enum ExamType { gceOLevel, gceALevel, bepc, probatoire, bac }

class FirestoreExamModel {
  final String id;
  final String title;
  final String subtitle;
  final String subject;
  final String year;
  final String examType;
  final String pdfUrl;
  final String? level;
  final bool hasMarkingGuide;

  FirestoreExamModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.subject,
    required this.year,
    required this.examType,
    required this.pdfUrl,
    this.level,
    this.hasMarkingGuide = false,
  });

  factory FirestoreExamModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FirestoreExamModel(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      subject: data['subject'] ?? '',
      year: data['year'] ?? '',
      examType: data['examType'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      level: data['level'],
      hasMarkingGuide: data['hasMarkingGuide'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'subject': subject,
      'year': year,
      'examType': examType,
      'pdfUrl': pdfUrl,
      if (level != null) 'level': level,
      'hasMarkingGuide': hasMarkingGuide,
    };
  }

  ExamModel toExamModel() {
    return ExamModel(
      id: id,
      type: _stringToExamType(examType),
      subject: subject,
      year: int.tryParse(year) ?? DateTime.now().year,
      session: 'June',
      pdfUrl: pdfUrl,
      totalQuestions: 0,
      totalMarks: 100,
      language: 'English',
      createdAt: DateTime.now(),
    );
  }

  ExamType _stringToExamType(String type) {
    switch (type.toLowerCase()) {
      case 'gceolevel':
      case 'gce o level':
        return ExamType.gceOLevel;
      case 'gcealevel':
      case 'gce a level':
        return ExamType.gceALevel;
      case 'bepc':
        return ExamType.bepc;
      case 'probatoire':
        return ExamType.probatoire;
      case 'bac':
        return ExamType.bac;
      default:
        return ExamType.gceOLevel;
    }
  }
}

class ExamModel {
  final String id;
  final ExamType type;
  final String subject;
  final int year;
  final String? session;
  final String? pdfUrl;
  final String? pdfLocalPath;
  final List<String> questionIds;
  final int totalQuestions;
  final int totalMarks;
  final String language;
  final DateTime createdAt;
  final bool isSynced;

  ExamModel({
    required this.id,
    required this.type,
    required this.subject,
    required this.year,
    this.session,
    this.pdfUrl,
    this.pdfLocalPath,
    this.questionIds = const [],
    required this.totalQuestions,
    required this.totalMarks,
    required this.language,
    required this.createdAt,
    this.isSynced = false,
  });

  factory ExamModel.fromFirestoreExam(FirestoreExamModel firestoreExam) {
    return ExamModel(
      id: firestoreExam.id,
      type: _stringToExamType(firestoreExam.examType),
      subject: firestoreExam.subject,
      year: int.tryParse(firestoreExam.year) ?? DateTime.now().year,
      session: 'June',
      pdfUrl: firestoreExam.pdfUrl,
      pdfLocalPath: null,
      questionIds: [],
      totalQuestions: 0,
      totalMarks: 100,
      language: 'English',
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  static ExamType _stringToExamType(String type) {
    switch (type.toLowerCase()) {
      case 'gceolevel':
      case 'gce o level':
        return ExamType.gceOLevel;
      case 'gcealevel':
      case 'gce a level':
        return ExamType.gceALevel;
      case 'bepc':
        return ExamType.bepc;
      case 'probatoire':
        return ExamType.probatoire;
      case 'bac':
        return ExamType.bac;
      default:
        return ExamType.gceOLevel;
    }
  }

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      type: ExamType.values.firstWhere(
            (e) => e.toString() == 'ExamType.${json['type']}',
      ),
      subject: json['subject'] as String,
      year: json['year'] as int,
      session: json['session'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      pdfLocalPath: json['pdfLocalPath'] as String?,
      questionIds: (json['questionIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      totalQuestions: json['totalQuestions'] as int,
      totalMarks: json['totalMarks'] as int,
      language: json['language'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'subject': subject,
      'year': year,
      'session': session,
      'pdfUrl': pdfUrl,
      'pdfLocalPath': pdfLocalPath,
      'questionIds': questionIds,
      'totalQuestions': totalQuestions,
      'totalMarks': totalMarks,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  ExamModel copyWith({
    String? id,
    ExamType? type,
    String? subject,
    int? year,
    String? session,
    String? pdfUrl,
    String? pdfLocalPath,
    List<String>? questionIds,
    int? totalQuestions,
    int? totalMarks,
    String? language,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return ExamModel(
      id: id ?? this.id,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      year: year ?? this.year,
      session: session ?? this.session,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      pdfLocalPath: pdfLocalPath ?? this.pdfLocalPath,
      questionIds: questionIds ?? this.questionIds,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalMarks: totalMarks ?? this.totalMarks,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}