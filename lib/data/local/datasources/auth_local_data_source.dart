import 'dart:convert';

import 'package:couple_book/core/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/auth_entity.dart';

class AuthLocalDataSource {
  static final AuthLocalDataSource instance = AuthLocalDataSource._internal();

  factory AuthLocalDataSource() => instance;

  AuthLocalDataSource._internal();

  static const _authKey = 'AUTH_INFO';

  Future<void> saveAuthInfo(AuthEntity auth) async {
    await SecureStorageHelper.setItem(_authKey, jsonEncode(auth.toJson()));
  }

  Future<AuthEntity?> getAuthInfo() async {
    final data = await SecureStorageHelper.getItem(_authKey);
    return data != null ? AuthEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearAuthInfo() async {
    await SecureStorageHelper.deleteItem(_authKey);
  }
}
