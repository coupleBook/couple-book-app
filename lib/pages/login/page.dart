import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/pages/login/login_platform.dart';
import 'package:couple_book/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../gen/assets.gen.dart';
import '../../style/text_style.dart';
import 'login_service.dart';

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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("platform", platform.name);
      if (isLoggedIn && mounted) {
        context.goNamed(ViewRoute.coupleAnniversary.name);
      }
    } catch (e) {
      logger.e('$platform 로그인 오류: $e');
    }
  }

  Widget _buildSignInButton({
    required VoidCallback onPressed,
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
              const AppText(
                '커플북과 함께 우리의\n소중한 추억을 기록해요.',
                style: TypoStyle.notoSansSemiBold22,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 68),

              // Sub Text
              const AppText('SNS 계정으로 간편 가입하기',
                  style: TypoStyle.notoSansR14_1_4,
                  color: ColorName.defaultGray,
                  letterSpacing: -1.2),
              const SizedBox(height: 26),

              // Google Sign In Button
              _buildSignInButton(
                onPressed: () => _handleSignIn(LoginPlatform.google),
                text: '구글 계정으로 가입하기',
                icon: Assets.icons.googleIcon.svg(),
                backgroundColor: ColorName.defaultBlack,
                textColor: ColorName.white,
              ),
              const SizedBox(height: 24),
              _buildSignInButton(
                onPressed: () => _handleSignIn(LoginPlatform.naver),
                text: '네이버로 가입하기',
                icon: Assets.icons.naverIcon.svg(),
                backgroundColor: ColorName.defaultBlack,
                textColor: ColorName.white,
              ),
              const SizedBox(height: 24),
              _buildSignInButton(
                onPressed: () {},
                text: '카카오톡으로 가입하기',
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
