import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../core/l10n/l10n.dart';
import '../../data/service/login_service.dart';
import '../../gen/assets.gen.dart';
import '../../style/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final logger = Logger();
  final LoginService _loginService = LoginService();

  static const double _buttonWidth = 320;
  static const double _buttonHeight = 58;
  static const double _buttonBorderRadius = 12;

  Future<void> _handleSignIn(LoginPlatform platform) async {
    try {
      bool isLoggedIn = await _loginService.signIn(platform);
      if (isLoggedIn && mounted) {
        context.goNamed(ViewRoute.signupAnimation.name);
      }
    } catch (e) {
      logger.e('$platform 로그인 오류: $e');
    }
  }

  /// ************************************************
  /// 로그인 버튼 공통 처리
  /// TODO: 나중엔 버튼도 공통 컴포넌트 상위로 분리 해야함
  /// ************************************************
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
    return Scaffold(
      backgroundColor: ColorName.backgroundColor, // 배경색 설정
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 수평 여백
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heart Image
              SizedBox(
                width: 310, // 이미지 너비
                height: 98, // 이미지 높이
                child: Assets.icons.appLogoIcon.svg(width: 310, height: 98),
              ),
              const SizedBox(height: 12), // 46px 자간
              AppText(
                l10n.loginPageTitle,
                style: TypoStyle.notoSansSemiBold22,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 68),

              // Sub Text절
              Padding(
                padding: const EdgeInsets.only(top: 6), // 위로 6px의 여백 추가
                child: AppText(
                  l10n.loginPageSubTitle,
                  style: TypoStyle.notoSansR14_1_4,
                  color: ColorName.defaultGray,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 25),

              // Google Sign In Button
              _buildSignInButton(
                onPressed: () => _handleSignIn(LoginPlatform.google),
                text: l10n.signInGoogle,
                icon: Assets.icons.googleIcon.svg(),
                backgroundColor: ColorName.defaultBlack,
                textColor: ColorName.white,
              ),
              const SizedBox(height: 18),
              _buildSignInButton(
                onPressed: () => _handleSignIn(LoginPlatform.naver),
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
  }
}
