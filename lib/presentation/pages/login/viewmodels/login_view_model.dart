import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/service/login_service.dart';
import 'package:couple_book/presentation/pages/login/models/login_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService;
  LoginState _state;

  LoginViewModel({
    required LoginService loginService,
  })  : _loginService = loginService,
        _state = LoginState();

  LoginState get state => _state;

  Future<void> handleSignIn(LoginPlatform platform, BuildContext context) async {
    try {
      _state = _state.copyWith(
        isLoading: true,
        currentPlatform: platform,
        errorMessage: null,
      );
      notifyListeners();

      bool isLoggedIn = await _loginService.signIn(platform);
      if (isLoggedIn && context.mounted) {
        context.goNamed(ViewRoute.signupAnimation.name);
      } else {
        _state = _state.copyWith(isLoading: false);
        notifyListeners();
      }
    } catch (e) {
      logger.e('$platform 로그인 오류: $e');
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }
}
