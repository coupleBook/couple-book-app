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
    await secureStorage.write(
      key: key,
      value: value,
    );
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
    if (accessToken != null) {
      return accessToken;
    } else {
      return '';
    }
  } catch (e) {
    logger.e('getAccessToken error: $e');
    return '';
  }
}

/// ************************************************
/// 로그아웃 시 액세스 토큰 삭제 함수 TODO: 추후 수정
/// ************************************************
Future<void> logout() async {
  await secureStorage.delete(key: 'ACCESS_TOKEN');
  await secureStorage.delete(key: 'MY_INFO');
  await secureStorage.delete(key: 'ANNIVERSARY_KEY');
}
