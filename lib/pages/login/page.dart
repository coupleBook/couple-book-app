import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../gen/assets.gen.dart';
import '../../router.dart';
import '../../style/text_style.dart';
import 'package:logger/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final logger = Logger();

  void _clickSignInButton() {
    logger.d("구글 로그인 버튼 클릭");
    context.goNamed(ViewRoute.home.name);
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
              const AppText(
                'SNS 계정으로 간편 가입하기',
                style: TypoStyle.notoSansR14_1_4,
                color: ColorName.defaultGray,
                letterSpacing: -1.2
              ),
              const SizedBox(height: 26),

              // Google Sign In Button
              ElevatedButton(
                onPressed: _clickSignInButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.defaultBlack, // 버튼 배경색
                  foregroundColor: ColorName.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: const Size(320, 58), // 버튼 크기
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글게 설정
                  ),
                  shadowColor: const Color(0x4D485629), // 그림자 색상 설정 (0x4D는 30% 투명도)
                  elevation: 4, // 그림자 높이 설정
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 중앙 정렬
                  children: [
                    SizedBox(
                      width: 12, // 아이콘 너비
                      child: Assets.icons.googleIcon.svg(),
                    ),
                    const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격 조정
                    const AppText(
                      '구글 계정으로 가입하기',
                      style: TypoStyle.notoSansR14_1_4,
                      color: ColorName.white
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Naver Sign In Button
              ElevatedButton(
                onPressed: _clickSignInButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.defaultBlack, // 버튼 배경색
                  foregroundColor: ColorName.white, // 글자색
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: const Size(320, 58), // 버튼 크기
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글게 설정
                  ),
                  shadowColor: const Color(0x4D485629), // 그림자 색상 설정 (0x4D는 30% 투명도)
                  elevation: 4, // 그림자 높이 설정
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 중앙 정렬
                  children: [
                    SizedBox(
                      width: 12, // 아이콘 너비
                      child: Assets.icons.naverIcon.svg(),
                    ),
                    const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격 조정
                    const AppText(
                      '네이버로 가입하기',
                      style: TypoStyle.notoSansR14_1_4,
                      color: ColorName.white
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kakao Sign In Button
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDEE8C4), // 버튼 배경색
                  foregroundColor: const Color(0xFF787D6F), // 글자색
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: const Size(320, 58), // 버튼 크기
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 모서리 둥글게 설정
                  ),
                  // shadowColor: const Color(0x4D485629), // 그림자 색상 설정 (0x4D는 30% 투명도)
                  elevation: 0, // 그림자 높이 설정
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 중앙 정렬
                  children: [
                    SizedBox(
                      width: 12, // 아이콘 너비
                      child: Assets.icons.kakaoIcon.svg(),
                    ),
                    const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격 조정
                    const Text(
                      '카카오톡으로 가입하기',
                      style: TypoStyle.notoSansR14_1_4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
