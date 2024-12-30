import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/local/last_login_local_data_source.dart';
import 'package:couple_book/data/service/logout_service.dart';
import 'package:couple_book/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class LogoutController {
  final Logger logger = Logger();

  final BuildContext context;
  late LoginPlatform? currentPlatform;
  final lastLoginLocalDataSource = LastLoginLocalDataSource();
  final logoutService = LogoutService();

  LogoutController(this.context);

  Future<void> loadCurrentPlatform() async {
    var lastLoginEntity = await lastLoginLocalDataSource.getLastLogin();
    currentPlatform = lastLoginEntity?.platform;
  }

  Future<void> handleLogout(LoginPlatform platform) async {
    try {
      await logoutService.signOut(platform);
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToLogin() {
    context.goNamed(ViewRoute.login.name);
  }
}
