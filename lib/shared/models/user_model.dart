/// User roles in the Kingdom Quest platform
enum UserRole { member, admin }

/// Gender options for anonymous display names
enum Gender { male, female, preferNotToSay }

/// Represents a user/member in the system
class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String displayName;
  final String? avatarUrl;
  final UserRole role;
  final String? churchId;
  final Gender gender;
  final String? bio;
  final DateTime? dateOfBirth;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.displayName,
    this.avatarUrl,
    this.role = UserRole.member,
    this.churchId,
    this.gender = Gender.preferNotToSay,
    this.bio,
    this.dateOfBirth,
    required this.createdAt,
  });

  /// Formatted anonymous display name based on gender
  String get anonymousName {
    switch (gender) {
      case Gender.male:
        return 'Anonymous Brother';
      case Gender.female:
        return 'Anonymous Sister';
      case Gender.preferNotToSay:
        return 'Anonymous Member';
    }
  }

  bool get isAdmin => role == UserRole.admin;

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? displayName,
    String? avatarUrl,
    UserRole? role,
    String? churchId,
    Gender? gender,
    String? bio,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      churchId: churchId ?? this.churchId,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
