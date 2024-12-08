import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

/// 앱 내부에 저장하는 데이터
const secureStorage = FlutterSecureStorage(
  aOptions: const AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

/// ************************************************
/// 액세스 토큰 로컬 스토리지에 저장 하는 함수
/// ************************************************
Future<void> setAccessToken(String accessToken) async {
  String key = 'ACCESS_TOKEN';
  String value = accessToken;

  try {
    await secureStorage.write(key: key, value: value);
    logger.d('액세스 토큰이 저장되었습니다.');
  } catch (e) {
    logger.e('setAccessToken error: $e');
    return;
  }
}

/// ************************************************
/// 액세스 토큰 로컬 스토리지 에서 가져오는 함수
/// ************************************************
Future<String> getAccessToken() async {
  try {
    String? accessToken = await secureStorage.read(key: 'ACCESS_TOKEN');
    return accessToken ?? '';
  } catch (e) {
    logger.e('getAccessToken error: $e');
    return '';
  }
}

/// ************************************************
/// 리프레시 토큰 저장
/// ************************************************
Future<void> setRefreshToken(String refreshToken) async {
  String key = 'REFRESH_TOKEN';
  String value = refreshToken;

  try {
    await secureStorage.write(key: key, value: value);
    logger.d('리프레시 토큰이 저장되었습니다.');
  } catch (e) {
    logger.e('setRefreshToken error: $e');
  }
}

/// ************************************************
/// 리프레시 토큰 가져오기
/// ************************************************
Future<String> getRefreshToken() async {
  try {
    String? refreshToken = await secureStorage.read(key: 'REFRESH_TOKEN');
    return refreshToken ?? '';
  } catch (e) {
    logger.e('getRefreshToken error: $e');
    return '';
  }
}

/// ************************************************
/// 로그아웃 시 액세스 토큰 삭제 함수 TODO: 추후 수정
/// ************************************************
Future<void> logout() async {
  try {
    await secureStorage.delete(key: 'ACCESS_TOKEN');
    await secureStorage.delete(key: 'REFRESH_TOKEN');
    await secureStorage.delete(key: 'MY_INFO');
    await secureStorage.delete(key: 'ANNIVERSARY_KEY');
    logger.d('모든 토큰과 사용자 데이터가 삭제되었습니다.');
  } catch (e) {
    logger.e('logout error: $e');
  }
}
