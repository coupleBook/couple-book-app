import 'dart:convert';

import '../../core/storage/secure_storage_helper.dart';
import 'entities/user_entity.dart';

class UserLocalDataSource {
  static final UserLocalDataSource instance = UserLocalDataSource._internal();

  factory UserLocalDataSource() => instance;

  UserLocalDataSource._internal();

  static const _userInfoKey = 'USER_INFO';

  Future<void> saveUser(UserEntity user) async {
    await SecureStorageHelper.setItem(_userInfoKey, jsonEncode(user.toJson()));
  }

  Future<UserEntity?> getUser() async {
    final data = await SecureStorageHelper.getItem(_userInfoKey);
    return data != null ? UserEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearUser() async {
    await SecureStorageHelper.deleteItem(_userInfoKey);
  }
}
