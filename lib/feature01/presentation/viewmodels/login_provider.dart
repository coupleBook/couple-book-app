import 'package:couple_book/core/providers/data_providers.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../core/routes/view_route.dart';

final logger = Logger();

class LoginState {
  final bool isLoggedIn;

  LoginState({this.isLoggedIn = false});

  LoginState copyWith({bool? isLoggedIn}) {
    return LoginState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginService loginService;

  LoginNotifier(this.loginService) : super(LoginState());

  Future<void> handleSignIn(BuildContext context, LoginPlatform platform) async {
    try {
      bool success = await loginService.signIn(platform);
      if (success && context.mounted) {
        context.goNamed(ViewRoute.signupAnimation.name);
      }
    } catch (e) {
      logger.e('$platform 로그인 오류: $e');
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.watch(loginServiceProvider));
});
