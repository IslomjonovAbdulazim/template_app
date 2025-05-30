import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

/// User model representing user data throughout the application
@JsonSerializable()
class UserModel extends Equatable {
  /// Unique user identifier
  @JsonKey(name: 'id')
  final String id;

  /// User's email address
  @JsonKey(name: 'email')
  final String email;

  /// User's username (optional)
  @JsonKey(name: 'username')
  final String? username;

  /// User's first name
  @JsonKey(name: 'first_name')
  final String? firstName;

  /// User's last name
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// User's full name (computed or provided)
  @JsonKey(name: 'full_name')
  final String? fullName;

  /// User's phone number
  @JsonKey(name: 'phone')
  final String? phone;

  /// User's date of birth
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;

  /// User's gender
  @JsonKey(name: 'gender')
  final String? gender;

  /// User's profile avatar URL
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// User's bio or description
  @JsonKey(name: 'bio')
  final String? bio;

  /// User's location/address
  @JsonKey(name: 'location')
  final String? location;

  /// User's website URL
  @JsonKey(name: 'website')
  final String? website;

  /// User's account status
  @JsonKey(name: 'status')
  final UserStatus status;

  /// Whether user's email is verified
  @JsonKey(name: 'email_verified')
  final bool emailVerified;

  /// Whether user's phone is verified
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;

  /// User's role in the system
  @JsonKey(name: 'role')
  final UserRole role;

  /// User's preferences
  @JsonKey(name: 'preferences')
  final UserPreferences? preferences;

  /// Account creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last profile update timestamp
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Last login timestamp
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;

  /// Whether user is currently online
  @JsonKey(name: 'is_online')
  final bool? isOnline;

  /// User's subscription status
  @JsonKey(name: 'subscription')
  final UserSubscription? subscription;

  /// Additional metadata
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
    this.bio,
    this.location,
    this.website,
    this.status = UserStatus.active,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.role = UserRole.user,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.isOnline,
    this.subscription,
    this.metadata,
  });

  /// Create empty user instance
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

  /// Get user's display name (priority: fullName -> firstName lastName -> username -> email)
  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!;
    }

    if (firstName != null && lastName != null) {
      return '${firstName!} ${lastName!}'.trim();
    }

    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }

    if (username != null && username!.isNotEmpty) {
      return username!;
    }

    return email;
  }

  /// Get user's initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }

    if (fullName != null && fullName!.isNotEmpty) {
      final parts = fullName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }

    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }

    if (username != null && username!.isNotEmpty) {
      return username![0].toUpperCase();
    }

    return email.isNotEmpty ? email[0].toUpperCase() : 'U';
  }

  /// Check if user profile is complete
  bool get isProfileComplete {
    return firstName != null &&
        lastName != null &&
        phone != null &&
        avatarUrl != null;
  }

  /// Check if user is verified (both email and phone)
  bool get isFullyVerified => emailVerified && phoneVerified;

  /// Check if user is active
  bool get isActive => status == UserStatus.active;

  /// Check if user is suspended
  bool get isSuspended => status == UserStatus.suspended;

  /// Check if user is banned
  bool get isBanned => status == UserStatus.banned;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is moderator
  bool get isModerator => role == UserRole.moderator;

  /// Check if user has premium subscription
  bool get hasPremiumSubscription => subscription?.isPremium == true;

  /// Get user's age (if date of birth is provided)
  int? get age {
    if (dateOfBirth == null) return null;

    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;

    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }

    return age;
  }

  /// Check if user was created today
  bool get isNewUser {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  /// Get formatted creation date
  String get formattedCreationDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
    String? bio,
    String? location,
    String? website,
    UserStatus? status,
    bool? emailVerified,
    bool? phoneVerified,
    UserRole? role,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? isOnline,
    UserSubscription? subscription,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isOnline: isOnline ?? this.isOnline,
      subscription: subscription ?? this.subscription,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    firstName,
    lastName,
    phone,
    status,
    role,
    emailVerified,
    phoneVerified,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, status: $status)';
  }
}

/// User status enumeration
enum UserStatus {
  @JsonValue('active')
  active,

  @JsonValue('inactive')
  inactive,

  @JsonValue('suspended')
  suspended,

  @JsonValue('banned')
  banned,

  @JsonValue('pending_verification')
  pendingVerification,
}

/// User role enumeration
enum UserRole {
  @JsonValue('user')
  user,

  @JsonValue('moderator')
  moderator,

  @JsonValue('admin')
  admin,

  @JsonValue('super_admin')
  superAdmin,
}

/// User preferences model
@JsonSerializable()
class UserPreferences extends Equatable {
  /// Language preference
  @JsonKey(name: 'language')
  final String language;

  /// Theme preference (light/dark/system)
  @JsonKey(name: 'theme')
  final String theme;

  /// Notification preferences
  @JsonKey(name: 'notifications')
  final NotificationPreferences notifications;

  /// Privacy preferences
  @JsonKey(name: 'privacy')
  final PrivacyPreferences privacy;

  /// App-specific preferences
  @JsonKey(name: 'app_settings')
  final Map<String, dynamic>? appSettings;

  const UserPreferences({
    required this.language,
    required this.theme,
    required this.notifications,
    required this.privacy,
    this.appSettings,
  });

  /// Create default preferences
  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      language: 'en',
      theme: 'system',
      notifications: NotificationPreferences(),
      privacy: PrivacyPreferences(),
    );
  }

  /// Create from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  /// Copy with new values
  UserPreferences copyWith({
    String? language,
    String? theme,
    NotificationPreferences? notifications,
    PrivacyPreferences? privacy,
    Map<String, dynamic>? appSettings,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      appSettings: appSettings ?? this.appSettings,
    );
  }

  @override
  List<Object?> get props => [language, theme, notifications, privacy, appSettings];
}

/// Notification preferences model
@JsonSerializable()
class NotificationPreferences extends Equatable {
  /// Enable push notifications
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;

  /// Enable email notifications
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;

  /// Enable SMS notifications
  @JsonKey(name: 'sms_enabled')
  final bool smsEnabled;

  /// Enable marketing notifications
  @JsonKey(name: 'marketing_enabled')
  final bool marketingEnabled;

  /// Enable sound for notifications
  @JsonKey(name: 'sound_enabled')
  final bool soundEnabled;

  /// Enable vibration for notifications
  @JsonKey(name: 'vibration_enabled')
  final bool vibrationEnabled;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.marketingEnabled = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  /// Create from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);

  /// Copy with new values
  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? marketingEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    pushEnabled,
    emailEnabled,
    smsEnabled,
    marketingEnabled,
    soundEnabled,
    vibrationEnabled,
  ];
}

/// Privacy preferences model
@JsonSerializable()
class PrivacyPreferences extends Equatable {
  /// Profile visibility (public/private/friends)
  @JsonKey(name: 'profile_visibility')
  final String profileVisibility;

  /// Show online status
  @JsonKey(name: 'show_online_status')
  final bool showOnlineStatus;

  /// Allow friend requests
  @JsonKey(name: 'allow_friend_requests')
  final bool allowFriendRequests;

  /// Show email to others
  @JsonKey(name: 'show_email')
  final bool showEmail;

  /// Show phone to others
  @JsonKey(name: 'show_phone')
  final bool showPhone;

  /// Allow data analytics
  @JsonKey(name: 'allow_analytics')
  final bool allowAnalytics;

  const PrivacyPreferences({
    this.profileVisibility = 'public',
    this.showOnlineStatus = true,
    this.allowFriendRequests = true,
    this.showEmail = false,
    this.showPhone = false,
    this.allowAnalytics = true,
  });

  /// Create from JSON
  factory PrivacyPreferences.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPreferencesFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$PrivacyPreferencesToJson(this);

  /// Copy with new values
  PrivacyPreferences copyWith({
    String? profileVisibility,
    bool? showOnlineStatus,
    bool? allowFriendRequests,
    bool? showEmail,
    bool? showPhone,
    bool? allowAnalytics,
  }) {
    return PrivacyPreferences(
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowFriendRequests: allowFriendRequests ?? this.allowFriendRequests,
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      allowAnalytics: allowAnalytics ?? this.allowAnalytics,
    );
  }

  @override
  List<Object?> get props => [
    profileVisibility,
    showOnlineStatus,
    allowFriendRequests,
    showEmail,
    showPhone,
    allowAnalytics,
  ];
}

/// User subscription model
@JsonSerializable()
class UserSubscription extends Equatable {
  /// Subscription type
  @JsonKey(name: 'type')
  final SubscriptionType type;

  /// Subscription status
  @JsonKey(name: 'status')
  final SubscriptionStatus status;

  /// Subscription start date
  @JsonKey(name: 'started_at')
  final DateTime startedAt;

  /// Subscription end date
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// Auto-renewal status
  @JsonKey(name: 'auto_renew')
  final bool autoRenew;

  /// Subscription features
  @JsonKey(name: 'features')
  final List<String>? features;

  const UserSubscription({
    required this.type,
    required this.status,
    required this.startedAt,
    this.expiresAt,
    this.autoRenew = false,
    this.features,
  });

  /// Create from JSON
  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);

  /// Check if subscription is premium
  bool get isPremium => type == SubscriptionType.premium || type == SubscriptionType.enterprise;

  /// Check if subscription is active
  bool get isActive => status == SubscriptionStatus.active;

  /// Check if subscription is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get days until expiration
  int? get daysUntilExpiration {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return 0;
    return expiresAt!.difference(now).inDays;
  }

  @override
  List<Object?> get props => [type, status, startedAt, expiresAt, autoRenew];
}

/// Subscription type enumeration
enum SubscriptionType {
  @JsonValue('free')
  free,

  @JsonValue('basic')
  basic,

  @JsonValue('premium')
  premium,

  @JsonValue('enterprise')
  enterprise,
}

/// Subscription status enumeration
enum SubscriptionStatus {
  @JsonValue('active')
  active,

  @JsonValue('expired')
  expired,

  @JsonValue('cancelled')
  cancelled,

  @JsonValue('suspended')
  suspended,
}