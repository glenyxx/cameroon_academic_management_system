class ResourceModel {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String subject;
  final String? classLevel;
  final String resourceUrl; // Google Drive, Dropbox, YouTube, etc.
  final String? thumbnailUrl;
  final String uploadedBy;
  final String uploaderName;
  final int sizeInBytes;
  final String language;
  final List<String> tags;
  final DateTime createdAt;
  final int viewCount;
  final int downloadCount;
  final bool isOfflineAvailable;
  final String? localPath;

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.subject,
    this.classLevel,
    required this.resourceUrl,
    this.thumbnailUrl,
    required this.uploadedBy,
    required this.uploaderName,
    this.sizeInBytes = 0,
    required this.language,
    this.tags = const [],
    required this.createdAt,
    this.viewCount = 0,
    this.downloadCount = 0,
    this.isOfflineAvailable = false,
    this.localPath,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ResourceType.values.firstWhere(
            (e) => e.toString() == 'ResourceType.${json['type']}',
      ),
      subject: json['subject'] as String,
      classLevel: json['classLevel'] as String?,
      resourceUrl: json['resourceUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      uploadedBy: json['uploadedBy'] as String,
      uploaderName: json['uploaderName'] as String,
      sizeInBytes: json['sizeInBytes'] as int? ?? 0,
      language: json['language'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: json['viewCount'] as int? ?? 0,
      downloadCount: json['downloadCount'] as int? ?? 0,
      isOfflineAvailable: json['isOfflineAvailable'] as bool? ?? false,
      localPath: json['localPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'subject': subject,
      'classLevel': classLevel,
      'resourceUrl': resourceUrl,
      'thumbnailUrl': thumbnailUrl,
      'uploadedBy': uploadedBy,
      'uploaderName': uploaderName,
      'sizeInBytes': sizeInBytes,
      'language': language,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'isOfflineAvailable': isOfflineAvailable,
      'localPath': localPath,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? title,
    String? description,
    ResourceType? type,
    String? subject,
    String? classLevel,
    String? resourceUrl,
    String? thumbnailUrl,
    String? uploadedBy,
    String? uploaderName,
    int? sizeInBytes,
    String? language,
    List<String>? tags,
    DateTime? createdAt,
    int? viewCount,
    int? downloadCount,
    bool? isOfflineAvailable,
    String? localPath,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      classLevel: classLevel ?? this.classLevel,
      resourceUrl: resourceUrl ?? this.resourceUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploaderName: uploaderName ?? this.uploaderName,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      localPath: localPath ?? this.localPath,
    );
  }
}

enum ResourceType {
  pdf,
  video,
  audio,
  note,
  quiz,
  flashcard,
}