import 'dart:convert';

import '../../core/storage/secure_storage_helper.dart';
import 'entities/local_user_entity.dart';

class LocalUserLocalDataSource {
  static final LocalUserLocalDataSource instance =
      LocalUserLocalDataSource._internal();

  factory LocalUserLocalDataSource() => instance;

  LocalUserLocalDataSource._internal();

  static const _localUserKey = 'LOCAL_USER_INFO';

  Future<void> saveLocalUser(LocalUserEntity localUser) async {
    await SecureStorageHelper.setItem(
        _localUserKey, jsonEncode(localUser.toJson()));
  }

  Future<LocalUserEntity?> getLocalUser() async {
    final data = await SecureStorageHelper.getItem(_localUserKey);
    return data != null ? LocalUserEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearLocalUser() async {
    await SecureStorageHelper.deleteItem(_localUserKey);
  }
}
