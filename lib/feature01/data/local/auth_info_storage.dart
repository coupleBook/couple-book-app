import 'dart:convert';

import 'package:couple_book/core/storage/secure_storage_helper.dart';
import 'package:couple_book/feature01/domain/models/auth_info.dart';

class AuthInfoStorage {
  static final AuthInfoStorage instance = AuthInfoStorage._internal();

  factory AuthInfoStorage() => instance;

  AuthInfoStorage._internal();

  static const _authKey = 'AUTH_INFO';

  Future<void> save(AuthInfo auth) async {
    await SecureStorageHelper.setItem(_authKey, jsonEncode(auth.toJson()));
  }

  Future<AuthInfo?> load() async {
    final raw = await SecureStorageHelper.getItem(_authKey);
    if (raw == null) return null;

    return AuthInfo.fromJson(jsonDecode(raw));
  }

  Future<void> clear() async {
    await SecureStorageHelper.deleteItem(_authKey);
  }
}
