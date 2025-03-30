import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/repositories/login_service.dart';
import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/presentation/pages/login/viewmodels/login_view_model.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const double _buttonWidth = 320;
  static const double _buttonHeight = 58;
  static const double _buttonBorderRadius = 12;

  late LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(
      loginService: LoginService(),
    );
  }

  Widget _buildSignInButton({
    required VoidCallback? onPressed,
    required String text,
    required Widget icon,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: const Size(_buttonWidth, _buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonBorderRadius),
        ),
        shadowColor: const Color(0x4D485629),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 12, child: icon),
          const SizedBox(width: 8),
          AppText(text, style: TypoStyle.notoSansR14_1_4, color: textColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: ColorName.backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 310,
                      height: 98,
                      child: Assets.icons.appLogoIcon.svg(width: 310, height: 98),
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      l10n.loginPageTitle,
                      style: TypoStyle.notoSansSemiBold22,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 68),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: AppText(
                        l10n.loginPageSubTitle,
                        style: TypoStyle.notoSansR14_1_4,
                        color: ColorName.defaultGray,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildSignInButton(
                      onPressed: () => viewModel.handleSignIn(LoginPlatform.google, context),
                      text: l10n.signInGoogle,
                      icon: Assets.icons.googleIcon.svg(),
                      backgroundColor: ColorName.defaultBlack,
                      textColor: ColorName.white,
                    ),
                    const SizedBox(height: 18),
                    _buildSignInButton(
                      onPressed: () => viewModel.handleSignIn(LoginPlatform.naver, context),
                      text: l10n.signInNaver,
                      icon: Assets.icons.naverIcon.svg(),
                      backgroundColor: ColorName.defaultBlack,
                      textColor: ColorName.white,
                    ),
                    const SizedBox(height: 18),
                    _buildSignInButton(
                      onPressed: null,
                      text: l10n.signInKakao,
                      icon: Assets.icons.kakaoIcon.svg(),
                      backgroundColor: const Color(0xFFDEE8C4),
                      textColor: const Color(0xFF787D6F),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
