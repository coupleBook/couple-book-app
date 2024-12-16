import 'package:couple_book/api/auth_api/auth_api.dart';
import 'package:couple_book/router.dart';
import 'package:couple_book/core/constants/login_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/security/auth_security.dart';

class LogoutController {
  final BuildContext context;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();
  final authApi = AuthApi();
  late LoginPlatform? currentPlatform;

  LogoutController(this.context);

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

    await _clearLocalToken();
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
    await logout();
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
