class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? schoolName;
  final String? className;
  final List<String> subjects;
  final String language; // 'en' or 'fr'
  final DateTime createdAt;
  final DateTime? lastSyncAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.schoolName,
    this.className,
    this.subjects = const [],
    this.language = 'en',
    required this.createdAt,
    this.lastSyncAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
            (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.student,
      ),
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      schoolName: json['schoolName'] as String?,
      className: json['className'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      language: json['language'] as String? ?? 'en',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSyncAt: json['lastSyncAt'] != null ? DateTime.parse(json['lastSyncAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'schoolName': schoolName,
      'className': className,
      'subjects': subjects,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phoneNumber,
    String? profileImageUrl,
    String? schoolName,
    String? className,
    List<String>? subjects,
    String? language,
    DateTime? createdAt,
    DateTime? lastSyncAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolName: schoolName ?? this.schoolName,
      className: className ?? this.className,
      subjects: subjects ?? this.subjects,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

enum UserRole {
  student,
  teacher,
  tutor,
  parent,
}