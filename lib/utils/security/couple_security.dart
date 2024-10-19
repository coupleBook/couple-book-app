


import 'dart:convert';

import 'package:couple_book/dto/auth/my_info_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();

/// 앱 내부에 저장하는 데이터
const secureStorage = FlutterSecureStorage(
  aOptions: const AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);


/// ************************************************
/// 처음 만난 날 로컬 스토리지에 저장 하는 함수
/// ************************************************
Future<void> setAnniversary(DateTime? anniversary) async {
  String key = 'ANNIVERSARY_KEY';
  String value = anniversary.toString();

  try {
    await secureStorage.write(
      key: key,
      value: value,
    );
  } catch (e) {
    logger.e('setAnniversary error: $e');
    return;
  }
}

/// ************************************************
/// 처음 만난 날 로컬 스토리지에서 가져오는 함수
/// ************************************************
Future<String> getAnniversary() async {
  try {
    String? anniversary = await secureStorage.read(key: 'ANNIVERSARY_KEY');
    if (anniversary != null) {
      final dateTimeAnniversary = DateFormat('yyyy-MM-dd').parse(anniversary);
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateTimeAnniversary);
      return formattedDate;
    } else {
      return '';
    }
  } catch (e) {
    logger.e('getAnniversary error: $e');
    return '';
  }
}


/// ************************************************
/// 내정보 로컬 스토리지에 저장하는 함수
/// ************************************************
Future<void> setMyInfo(MyInfoDto myInfo) async {
  String key = 'MY_INFO';
  String value = jsonEncode(myInfo.toJson());

  try {
    await secureStorage.write(
      key: key,
      value: value,
    );
    logger.d('setMyInfo: $value 저장 완료');
  } catch (e) {
    logger.e('setMyInfo error: $e');
  }
}


/// ************************************************
/// 내정보 로컬 스토리지에서 가져오는 함수
/// ************************************************
Future<MyInfoDto?> getMyInfo() async {
  String key = 'MY_INFO';
  try {
    String? myInfo = await secureStorage.read(key: key);

    if (myInfo != null) {
      try {
        Map<String, dynamic> json = jsonDecode(myInfo);
        return MyInfoDto.fromJson(json);
      } catch (e) {
        logger.e('JSON Parsing Error: $e');
        logger.e('Invalid JSON: $myInfo');
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    logger.e('getMyInfo error: $e');
    return null;
  }
}
