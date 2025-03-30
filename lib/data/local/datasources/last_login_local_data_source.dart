import 'dart:convert';

import 'package:couple_book/data/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/last_login_entity.dart';

class LastLoginLocalDataSource {
  static final LastLoginLocalDataSource instance = LastLoginLocalDataSource._internal();

  factory LastLoginLocalDataSource() => instance;

  LastLoginLocalDataSource._internal();

  static const _lastLoginKey = 'LAST_LOGIN_INFO';

  Future<void> saveLastLogin(LastLoginEntity lastLogin) async {
    await SecureStorageHelper.setItem(_lastLoginKey, jsonEncode(lastLogin.toJson()));
  }

  Future<LastLoginEntity?> getLastLogin() async {
    final data = await SecureStorageHelper.getItem(_lastLoginKey);
    return data != null ? LastLoginEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearLastLogin() async {
    await SecureStorageHelper.deleteItem(_lastLoginKey);
  }
}
