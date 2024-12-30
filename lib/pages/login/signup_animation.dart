import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/security/couple_security.dart';
import '../../data/models/response/common/my_info_response.dart';
import '../../router.dart';

class SignupAnimationPage extends StatefulWidget {
  const SignupAnimationPage({super.key});

  @override
  State<SignupAnimationPage> createState() => SignupAnimationPageState();
}

class SignupAnimationPageState extends State<SignupAnimationPage> {
  String userName = ''; // userName을 State 클래스의 상태로 선언

  @override
  void initState() {
    super.initState();
    _initAsync(); // 비동기 초기화 함수 호출
  }

  Future<void> _initAsync() async {
    await _loadUserName(); // 유저 정보 불러오기
    final anniversary = await getAnniversary();
    Timer(const Duration(milliseconds: 3700), () {
      if (anniversary.isEmpty) {
        context.goNamed(ViewRoute.coupleAnniversary.name);
      } else {
        context.goNamed(ViewRoute.home.name);
      }
    });
  }

  Future<void> _loadUserName() async {
    try {
      MyInfoResponse? myInfo = await getMyInfo();
      if (myInfo != null) {
        setState(() {
          userName = myInfo.name; // userName에 값 할당
        });
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDE7), // 이미지 배경색
      body: Center(
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
            Text(
              userName.isNotEmpty ? '$userName님 반가워요' : '환영합니다!',
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
