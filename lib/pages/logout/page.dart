import 'package:couple_book/env/environment.dart';
import 'package:couple_book/pages/login/login_platform.dart';
import 'package:couple_book/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutPage> {
  final secureStorage = const FlutterSecureStorage();
  final logger = Logger();
  late final Dio _dio;
  late LoginPlatform _currentPlatform;

  _LogoutViewState() {
    _dio = Dio(BaseOptions(
      baseUrl: Environment.restApiUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ));
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentPlatform();
  }

  Future<void> _loadCurrentPlatform() async {
    final prefs = await SharedPreferences.getInstance();
    final platformString = prefs.getString('platform') ?? '';
    setState(() {
      _currentPlatform = LoginPlatform.values.firstWhere(
        (e) => e.name == platformString,
        orElse: () => LoginPlatform.naver, // 기본값 설정
      );
    });
  }

  Future<void> _handleLogout(LoginPlatform platform) async {
    try {
      await signOut(platform);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그아웃 성공')),
        );

        context.goNamed(ViewRoute.login.name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그아웃 실패: $e')),
        );
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
      final response = await _dio.delete(
        '/api/v1/logout',
        options: Options(headers: {'Authorization': accessToken}),
      );
      logger.d('백엔드 로그아웃 성공: $response');
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
    logger.d('로컬 토큰 삭제 완료');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logout),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentPlatform == LoginPlatform.naver)
              ElevatedButton(
                onPressed: () => _handleLogout(LoginPlatform.naver),
                child: Text(l10n.logoutNaver),
              )
            else if (_currentPlatform == LoginPlatform.google)
              ElevatedButton(
                onPressed: () => _handleLogout(LoginPlatform.google),
                child: Text(l10n.logoutGoogle),
              ),
          ],
        ),
      ),
    );
  }
}
