import 'package:couple_book/env/environment.dart';
import 'package:couple_book/router.dart';
import 'package:couple_book/utils/constants/login_platform.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  final BuildContext context;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();
  late Dio _dio;
  late LoginPlatform? currentPlatform;

  LogoutController(this.context) {
    _dio = _createDioClient();
  }

  Dio _createDioClient() {
    return Dio(BaseOptions(
      baseUrl: Environment.restApiUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ));
  }

  Future<void> loadCurrentPlatform() async {
    final prefs = await SharedPreferences.getInstance();
    final platformString = prefs.getString('platform') ?? '';
    currentPlatform = LoginPlatform.values.firstWhere(
      (e) => e.name == platformString,
      orElse: () => LoginPlatform.naver, // 기본값 설정
    );
  }

  Future<void> handleLogout(LoginPlatform platform) async {
    try {
      await signOut(platform);
      if (context.mounted) {
        _showSnackBar('로그아웃 성공');
        _navigateToLogin();
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar('로그아웃 실패: $e');
        logger.e('로그아웃 오류: $e');
      }
    }
  }

  Future<void> signOut(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        await _naverSignOut();
        break;
      case LoginPlatform.google:
        await _googleSignOut();
        break;
    }

    await _logoutBackend();
    await _clearLocalToken();
  }

  Future<void> _logoutBackend() async {
    final accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken != null) {
      try {
        final response = await _dio.delete(
          '/api/v1/logout',
          options: Options(headers: {'Authorization': accessToken}),
        );
        logger.d('백엔드 로그아웃 성공: $response');
      } catch (e) {
        logger.e('백엔드 로그아웃 실패: $e');
        rethrow;
      }
    } else {
      logger.w('액세스 토큰이 없습니다. 로그아웃을 진행할 수 없습니다.');
    }
  }

  Future<void> _naverSignOut() async {
    try {
      await FlutterNaverLogin.logOut();
      logger.d('네이버 로그아웃 성공');
    } catch (error) {
      logger.e('네이버 로그아웃 오류: $error');
      rethrow;
    }
  }

  Future<void> _googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      logger.d('구글 로그아웃 성공');
    } catch (error) {
      logger.e('구글 로그아웃 오류: $error');
      rethrow;
    }
  }

  Future<void> _clearLocalToken() async {
    await secureStorage.delete(key: "accessToken");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('platform');
    logger.d('로컬 토큰 삭제 완료');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToLogin() {
    context.goNamed(ViewRoute.login.name);
  }
}
