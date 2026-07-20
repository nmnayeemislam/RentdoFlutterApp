import 'package:equatable/equatable.dart';

/// Authenticated user. Mirrors the API `UserResource`.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.role,
    this.isVerified = false,
    this.verificationStatus,
    this.language,
    this.currency,
    this.phoneVisibility,
    this.isBlocked = false,
    this.walletBalance,
  });

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? role;

  /// True only once an admin has approved the owner-verification document.
  final bool isVerified;

  /// `unverified` | `pending` | `verified` | `rejected`.
  final String? verificationStatus;
  final String? language;
  final String? currency;
  final String? phoneVisibility;
  final bool isBlocked;
  final num? walletBalance;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar'] as String?,
      role: json['role'] as String?,
      isVerified: json['is_verified'] == true,
      verificationStatus: json['verification_status'] as String?,
      language: json['language'] as String?,
      currency: json['currency'] as String?,
      phoneVisibility: json['phone_visibility'] as String?,
      isBlocked: json['is_blocked'] == true,
      walletBalance: json['wallet_balance'] as num?,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatarUrl,
        role,
        isVerified,
        verificationStatus,
        language,
        currency,
        phoneVisibility,
        isBlocked,
        walletBalance,
      ];
}
