import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../core/storage/shared_preferences_helper.dart';
import '../../domain/models/local_user_info.dart';

final logger = Logger();

class LocalUserInfoStorage {
  static final instance = LocalUserInfoStorage._internal();

  factory LocalUserInfoStorage() => instance;

  LocalUserInfoStorage._internal();

  static const _localUserKey = 'LOCAL_USER_INFO';

  Future<void> save(LocalUserInfo info) async {
    await SharedPreferencesHelper.setItem(_localUserKey, jsonEncode(info.toJson()));
  }

  Future<LocalUserInfo?> load() async {
    final data = await SharedPreferencesHelper.getItem(_localUserKey);
    if (data == null) return null;

    return LocalUserInfo.fromJson(jsonDecode(data));
  }

  Future<void> clear() async {
    await SharedPreferencesHelper.deleteItem(_localUserKey);
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
    final localUserEntity = await load();
    if (localUserEntity == null) return null;

    final anniversary = localUserEntity.anniversary!;
    return DateFormat('yyyy-MM-dd').parse(anniversary);
  }
}
