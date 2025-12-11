class ExamModel {
  final String id;
  final ExamType type;
  final String subject;
  final int year;
  final String? session; // e.g., "June", "June/July"
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

enum ExamType {
  gceOLevel,
  gceALevel,
  bepc,
  probatoire,
  bac,
}