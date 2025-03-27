import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/feature01/domain/usecases/login_usecase.dart';
import 'package:couple_book/feature01/presentation/components/sign_in_button.dart';
import 'package:couple_book/feature01/presentation/viewmodels/auth_info_provider.dart';
import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authInfoProvider.notifier);
    final loginUseCase = ref.read(loginUseCaseProvider);

    ref.listen(authInfoProvider, (prev, next) {
      if (next?.accessToken != null && next!.accessToken.isNotEmpty) {
        context.goNamed(ViewRoute.signupAnimation.name);
      }
    });

    return Scaffold(
      backgroundColor: ColorName.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.appLogoIcon.svg(width: 310, height: 98),
            const SizedBox(height: 46),
            Text(l10n.loginPageTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 68),
            SignInButton(
              onPressed: () async {
                final result = await loginUseCase.execute(LoginPlatform.google);
                await authNotifier.update(result.auth);
              },
              text: l10n.signInGoogle,
              icon: Assets.icons.googleIcon.svg(),
              backgroundColor: ColorName.defaultBlack,
              textColor: ColorName.white,
            ),
            const SizedBox(height: 18),
            SignInButton(
              onPressed: () async {
                final result = await loginUseCase.execute(LoginPlatform.naver);
                await authNotifier.update(result.auth);
              },
              text: l10n.signInNaver,
              icon: Assets.icons.naverIcon.svg(),
              backgroundColor: ColorName.defaultBlack,
              textColor: ColorName.white,
            ),
            const SizedBox(height: 18),
            SignInButton(
              onPressed: null,
              text: l10n.signInKakao,
              icon: Assets.icons.kakaoIcon.svg(),
              backgroundColor: ColorName.pointBtnBg,
              textColor: ColorName.defaultGray,
            ),
          ],
        ),
      ),
    );
  }
}
