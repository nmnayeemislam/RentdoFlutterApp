import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/models/user_model.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

/// API layer for the authenticated profile (`/me`) mutations.
class ProfileService {
  ProfileService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> update(Map<String, dynamic> body) async {
    final res = await _api.put<Map<String, dynamic>>(ApiEndpoints.me, data: body);
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _api.put<dynamic>(ApiEndpoints.mePassword, data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPassword,
      });

  Future<void> uploadPhoto(String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    await _api.upload<dynamic>(ApiEndpoints.mePhoto, formData: formData);
  }
}

final profileServiceProvider = Provider<ProfileService>(
  (ref) => ProfileService(ref.watch(apiClientProvider)),
);

@immutable
class ProfileEditState {
  const ProfileEditState({this.isSubmitting = false, this.error});
  final bool isSubmitting;
  final ApiException? error;

  ProfileEditState copyWith({bool? isSubmitting, ApiException? error, bool clearError = false}) =>
      ProfileEditState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Handles profile edits and password changes; syncs the updated user back into
/// [authViewModelProvider].
class ProfileViewModel extends AutoDisposeNotifier<ProfileEditState> {
  @override
  ProfileEditState build() => const ProfileEditState();

  Future<bool> updateProfile(Map<String, dynamic> changes) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final data = await ref.read(profileServiceProvider).update(changes);
      ref.read(authViewModelProvider.notifier).applyUser(UserModel.fromJson(data));
      state = state.copyWith(isSubmitting: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }

  Future<bool> uploadPhoto(String filePath) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await ref.read(profileServiceProvider).uploadPhoto(filePath);
      await ref.read(authViewModelProvider.notifier).refreshUser();
      state = state.copyWith(isSubmitting: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await ref.read(profileServiceProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );
      state = state.copyWith(isSubmitting: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }
}

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileEditState>(
        ProfileViewModel.new);
