import 'dart:convert';

import 'package:intl/intl.dart';

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

  Future<String> getAnniversary() async {
    final dateTimeAnniversary = await _getAnniversary();
    if (dateTimeAnniversary == null) {
      return '';
    }
    return DateFormat('yyyy-MM-dd').format(dateTimeAnniversary);
  }

  Future<DateTime?> getAnniversaryToDatetime() async {
    return _getAnniversary();
  }

  Future<DateTime?> _getAnniversary() async {
    final localUserEntity = await getLocalUser();
    if (localUserEntity == null) {
      return null;
    }
    final anniversary = localUserEntity.anniversary;
    return DateFormat('yyyy-MM-dd').parse(anniversary);
  }

  Future<void> clearLocalUser() async {
    await SecureStorageHelper.deleteItem(_localUserKey);
  }
}
