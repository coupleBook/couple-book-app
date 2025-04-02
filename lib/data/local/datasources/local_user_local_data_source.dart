import 'dart:convert';

import 'package:couple_book/data/storage/secure_storage_helper.dart';
import 'package:couple_book/data/storage/shared_preferences_helper.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LocalUserLocalDataSource {
  static final instance = LocalUserLocalDataSource._internal();

  factory LocalUserLocalDataSource() => instance;

  LocalUserLocalDataSource._internal();

  static const _localUserKey = 'LOCAL_USER_INFO';

  Future<void> saveLocalUser(LocalUserEntity localUser) async {
    await SharedPreferencesHelper.setItem(_localUserKey, jsonEncode(localUser.toJson()));
  }

  Future<LocalUserEntity?> getLocalUser() async {
    final data = await SharedPreferencesHelper.getItem(_localUserKey);

    if (data != null) {
      return LocalUserEntity.fromJson(jsonDecode(data));
    }

    // SecureStorage에서 SharedPreferences로 변경
    final item = await SecureStorageHelper.getItem(_localUserKey);
    if (item != null) {
      final localUserEntity = LocalUserEntity.fromJson(jsonDecode(item));
      await saveLocalUser(localUserEntity);
      await SecureStorageHelper.deleteItem(_localUserKey);

      return localUserEntity;
    }

    return null;
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
    await SharedPreferencesHelper.deleteItem(_localUserKey);
  }
}
