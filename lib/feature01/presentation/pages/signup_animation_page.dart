import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/view_route.dart';
import '../../../data/local/local_user_local_data_source.dart';
import '../../../data/local/user_local_data_source.dart';
import 'package:logger/logger.dart';

class SignupAnimationPage extends ConsumerStatefulWidget {
  const SignupAnimationPage({super.key});

  @override
  ConsumerState<SignupAnimationPage> createState() => SignupAnimationPageState();
}

class SignupAnimationPageState extends ConsumerState<SignupAnimationPage> {
  final logger = Logger();
  final localUserLocalDataSource = LocalUserLocalDataSource.instance;
  final userLocalDataSource = UserLocalDataSource.instance;
  String userName = ''; // 사용자 이름 상태

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _loadUserName();
    final anniversary = await localUserLocalDataSource.getAnniversary();

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 3700), () {
        if (mounted) {
          if (anniversary.isEmpty) {
            context.goNamed(ViewRoute.coupleAnniversary.name);
          } else {
            context.goNamed(ViewRoute.home.name);
          }
        }
      });
    }
  }

  Future<void> _loadUserName() async {
    try {
      var userEntity = await userLocalDataSource.getUser();
      if (userEntity != null && mounted) {
        setState(() {
          userName = userEntity.name;
        });
      }
    } catch (e) {
      logger.d('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDE7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
