import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final _logger = Logger();

  /// ************************************************
  /// SharedPreferences에 데이터 저장
  /// ************************************************
  static Future<void> setItem(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      _logger.d('$key 저장 완료');
    } catch (e) {
      _logger.e('setItem error for $key: $e');
    }
  }

  /// ************************************************
  /// SharedPreferences에서 데이터 읽기
  /// ************************************************
  static Future<String?> getItem(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      _logger.e('getItem error for $key: $e');
      return null;
    }
  }

  /// ************************************************
  /// SharedPreferences에서 데이터 삭제
  /// ************************************************
  static Future<void> deleteItem(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      _logger.d('$key 삭제 완료');
    } catch (e) {
      _logger.e('deleteItem error for $key: $e');
    }
  }

  /// ************************************************
  /// SharedPreferences에서 모든 데이터 삭제
  /// ************************************************
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.d('모든 데이터 삭제 완료');
    } catch (e) {
      _logger.e('clearAll error: $e');
    }
  }
}
