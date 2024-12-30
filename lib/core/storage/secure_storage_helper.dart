import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorageHelper {
  static final _logger = Logger();

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> setItem(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      _logger.d('$key 저장 완료');
    } catch (e) {
      _logger.e('setItem error for $key: $e');
    }
  }

  static Future<String?> getItem(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      _logger.e('getItem error for $key: $e');
      return null;
    }
  }

  static Future<void> deleteItem(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _logger.d('$key 삭제 완료');
    } catch (e) {
      _logger.e('removeItem error for $key: $e');
    }
  }
}
