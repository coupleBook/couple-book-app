import 'dart:async';
import 'dart:convert'; // jsonDecode 사용을 위해 필요
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dto/auth/my_info_dto.dart';
import '../../router.dart';
import '../../utils/security/couple_security.dart';

class SignupAnimationPage extends StatefulWidget {
  const SignupAnimationPage({Key? key}) : super(key: key);

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
    Timer(const Duration(milliseconds: 3700), () {
      context.goNamed(ViewRoute.coupleAnniversary.name);
    });
  }

  Future<void> _loadUserName() async {
    try {
      MyInfoDto? myInfo = await getMyInfo();
      if (myInfo != null && myInfo.name != null) {
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
