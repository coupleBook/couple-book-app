import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/data/service/logout_service.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/local/last_login_local_data_source.dart';

class LogoutController {
  final Logger logger = Logger();
  final BuildContext context;

  LoginPlatform? currentPlatform;
  final logoutService = LogoutService();
  final lastLoginLocalDataSource = LastLoginLocalDataSource();

  LogoutController(this.context);

  Future<void> loadCurrentPlatform() async {
    var lastLoginEntity = await lastLoginLocalDataSource.getLastLogin();
    currentPlatform = lastLoginEntity?.platform;
  }

  Future<void> handleLogout(LoginPlatform platform) async {
    try {
      await logoutService.signOut(platform);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그아웃 성공")),
        );
        context.goNamed(ViewRoute.login.name);
      }
    } catch (e) {
      logger.e('로그아웃 실패: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그아웃 실패: $e")),
        );
      }
    }
  }
}

