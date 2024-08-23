import 'package:COUPLE_BOOK/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';
import '../../style/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heart Image
              Assets.icons.c_heartIcon.svg(),
              const SizedBox(height: 24),
              const AppText(
                '커플북과 함께 우리의\n소중한 추억을 기록해요.',
                style: TypoStyle.seoyunB46_1_5,
                maxLines: 2,
                textAlign: TextAlign.center,
                color: ColorName.darkPurple,
              ),
              const SizedBox(height: 16),

              // Sub Text
              const Text(
                'SNS 계정으로 간편 가입하기',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Google Sign In Button
              ElevatedButton.icon(
                onPressed: () {
                  // Google Sign In 로직
                },
                icon: Assets.icons.c_googleIcon.svg(),
                label: const Text('구글 계정으로 가입하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBBC05), // 구글 버튼 배경색 수정
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: Size(320, 58), // 버튼 크기 수정
                ),
              ),
              const SizedBox(height: 16),

              // Kakao Sign In Button
              ElevatedButton.icon(
                onPressed: () {
                  // Kakao Sign In 로직
                },
                icon: const Icon(Icons.message, color: Colors.brown),
                label: const Text('카카오톡으로 가입하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: Size(320, 58), // 버튼 크기 수정
                ),
              ),
              const SizedBox(height: 16),

              // Naver Sign In Button
              ElevatedButton.icon(
                onPressed: () {
                  // Naver Sign In 로직
                },
                icon: const Icon(Icons.account_circle, color: Colors.green),
                label: const Text('네이버로 가입하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: Size(320, 58), // 버튼 크기 수정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
