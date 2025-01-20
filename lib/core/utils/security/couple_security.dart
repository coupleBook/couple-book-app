import 'dart:convert';

import 'package:couple_book/data/models/response/common/couple_info_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../data/models/response/common/my_info_response.dart';
import 'my_profile_image_dto.dart';

final logger = Logger();

/// 앱 내부에 저장하는 데이터
const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

/// ************************************************
/// 처음 만난 날 로컬 스토리지에서 가져오는 함수
/// ************************************************
Future<DateTime?> getAnniversaryToDatetime() async {
  try {
    String? anniversary = await secureStorage.read(key: 'ANNIVERSARY_KEY');
    if (anniversary != null) {
      final dateTimeAnniversary = DateFormat('yyyy-MM-dd').parse(anniversary);
      return dateTimeAnniversary;
    } else {
      return null;
    }
  } catch (e) {
    logger.e('getAnniversary error: $e');
    return null;
  }
}

/// ************************************************
/// 내정보 로컬 스토리지에 저장하는 함수
/// ************************************************
Future<void> setMyInfo(MyInfoResponse myInfo) async {
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
Future<MyInfoResponse?> getMyInfo() async {
  String key = 'MY_INFO';
  try {
    String? myInfo = await secureStorage.read(key: key);

    if (myInfo != null) {
      try {
        Map<String, dynamic> json = jsonDecode(myInfo);
        return MyInfoResponse.fromJson(json);
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

/// ************************************************
/// 내정보 로컬 스토리지에 저장하는 함수
/// ************************************************
Future<void> setCoupleInfo(CoupleInfoResponse coupleInfo) async {
  String key = 'COUPLE_INFO';
  String value = jsonEncode(coupleInfo.toJson());

  try {
    await secureStorage.write(
      key: key,
      value: value,
    );
    logger.d('setCoupleInfo: $value 저장 완료');
  } catch (e) {
    logger.e('setCoupleInfo error: $e');
  }
}

/// ************************************************
/// 내정보 로컬 스토리지에서 가져오는 함수
/// ************************************************
Future<CoupleInfoResponse?> getCoupleInfo() async {
  String key = 'COUPLE_INFO';
  try {
    String? coupleInfo = await secureStorage.read(key: key);

    if (coupleInfo != null) {
      try {
        Map<String, dynamic> json = jsonDecode(coupleInfo);
        return CoupleInfoResponse.fromJson(json);
      } catch (e) {
        logger.e('JSON Parsing Error: $e');
        logger.e('Invalid JSON: $coupleInfo');
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

/// ************************************************
/// 프로필 이미지 로컬 스토리지에 저장하는 함수
/// ************************************************
Future<void> setProfileImage(MyProfileImageDTO profileImage) async {
  String key = 'PROFILE_IMAGE';
  String value = jsonEncode(profileImage.toJson());

  try {
    await secureStorage.write(
      key: key,
      value: value,
    );
    logger.d('setProfileImage: $value 저장 완료');
  } catch (e) {
    logger.e('setProfileImage error: $e');
  }
}

/// ************************************************
/// 프로필 이미지 로컬 스토리지에서 가져오는 함수
/// ************************************************
Future<MyProfileImageDTO?> getProfileImage() async {
  String key = 'PROFILE_IMAGE';
  try {
    String? profileImage = await secureStorage.read(key: key);

    if (profileImage != null) {
      try {
        Map<String, dynamic> json = jsonDecode(profileImage);
        return MyProfileImageDTO.fromJson(json);
      } catch (e) {
        logger.e('JSON Parsing Error: $e');
        logger.e('Invalid JSON: $profileImage');
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    logger.e('getProfileImage error: $e');
    return null;
  }
}

/// ************************************************
/// 프로필 이미지 로컬 스토리지에서 삭제하는 함수
/// ************************************************
Future<void> deleteProfileImage() async {
  String key = 'PROFILE_IMAGE';

  try {
    await secureStorage.delete(key: key);
    logger.d('deleteProfileImage: PROFILE_IMAGE 삭제 완료');
  } catch (e) {
    logger.e('deleteProfileImage error: $e');
  }
}
