import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/feature01/domain/usecases/login_usecase.dart';
import 'package:couple_book/feature01/presentation/viewmodels/auth_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../data/local/entities/enums/login_platform.dart';

final logger = Logger();

class LoginViewModel {
  final Ref ref;

  LoginViewModel(this.ref);

  Future<void> signIn(BuildContext context, LoginPlatform platform) async {
    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final authNotifier = ref.read(authInfoProvider.notifier);

      final loginResult = await loginUseCase.execute(platform);
      await authNotifier.update(loginResult.auth);

      if (context.mounted) {
        context.goNamed(ViewRoute.signupAnimation.name);
      }
    } catch (e, stack) {
      logger.e('$platform 로그인 실패', error: e, stackTrace: stack);
    }
  }
}

/// Provider 선언
final loginViewModelProvider = Provider<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});
