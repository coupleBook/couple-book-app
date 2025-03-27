import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/feature01/domain/models/auth_model.dart';
import 'package:couple_book/feature01/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../data/local/entities/enums/login_platform.dart';

final logger = Logger();

/// 상태 정의
class LoginState {
  final bool isLoggedIn;
  final AuthModel? auth;

  LoginState({this.isLoggedIn = false, this.auth});

  LoginState copyWith({bool? isLoggedIn, AuthModel? auth}) {
    return LoginState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      auth: auth ?? this.auth,
    );
  }
}

/// ViewModel 정의
class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase) : super(LoginState());

  Future<void> signIn(BuildContext context, LoginPlatform platform) async {
    try {
      final loginResultModel = await loginUseCase.execute(platform);

      state = state.copyWith(isLoggedIn: true, auth: loginResultModel.auth);

      if (context.mounted) {
        context.goNamed(ViewRoute.signupAnimation.name);
      }
    } catch (e) {
      logger.e('$platform 로그인 오류: $e');
    }
  }
}

/// Provider 선언
final loginProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return LoginViewModel(loginUseCase);
});
