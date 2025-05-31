import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

/// Simple user model - just basic user data
@JsonSerializable()
class UserModel extends Equatable {
  /// User ID
  @JsonKey(name: 'id')
  final String id;

  /// User's email
  @JsonKey(name: 'email')
  final String email;

  /// User's first name
  @JsonKey(name: 'first_name')
  final String? firstName;

  /// User's last name
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// User's avatar URL
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// Account creation date
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update date
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create empty user
  factory UserModel.empty() {
    final now = DateTime.now();
    return UserModel(
      id: '',
      email: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Get user's display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '${firstName!} ${lastName!}'.trim();
    }
    if (firstName != null) {
      return firstName!;
    }
    return email;
  }

  /// Get user's initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null) {
      return firstName![0].toUpperCase();
    }
    return email.isNotEmpty ? email[0].toUpperCase() : 'U';
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    avatarUrl,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName)';
  }
}