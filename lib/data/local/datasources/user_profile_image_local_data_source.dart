import 'dart:convert';

import 'package:couple_book/core/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/user_profile_image_entity.dart';

class UserProfileImageLocalDataSource {
  static final UserProfileImageLocalDataSource instance = UserProfileImageLocalDataSource._internal();

  factory UserProfileImageLocalDataSource() => instance;

  UserProfileImageLocalDataSource._internal();

  static const _userProfileImageKey = 'USER_PROFILE_IMAGE';

  Future<void> saveProfileImage(UserProfileImageEntity image) async {
    await SecureStorageHelper.setItem(_userProfileImageKey, jsonEncode(image.toJson()));
  }

  Future<UserProfileImageEntity?> getProfileImage() async {
    final data = await SecureStorageHelper.getItem(_userProfileImageKey);
    return data != null ? UserProfileImageEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearProfileImage() async {
    await SecureStorageHelper.deleteItem(_userProfileImageKey);
  }
}
