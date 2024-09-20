import 'dart:async';
import 'package:couple_book/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupAnimationPage extends StatefulWidget {
  // TODO 유저 정보 받아오기
  final String userName = '둘리';

  const SignupAnimationPage({super.key});

  @override
  State<SignupAnimationPage> createState() => SignupAnimationPageState();
}

class SignupAnimationPageState extends State<SignupAnimationPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 3700), () {
      context.goNamed(ViewRoute.coupleAnniversary.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDE7), // 이미지 배경색
      body: Center( // Center 위젯 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(), // 상단 여백
            Image.asset(
              'assets/icons/signup.gif',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              '커플북 가입 완료!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.userName}님 반가워요',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), // 하단 여백
          ],
        ),
      ),
    );
  }
}
