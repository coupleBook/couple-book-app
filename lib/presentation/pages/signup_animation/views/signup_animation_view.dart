import 'dart:async';
import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SignupAnimationView extends StatefulWidget {
  const SignupAnimationView({super.key});

  @override
  State<SignupAnimationView> createState() => _SignupAnimationViewState();
}

class _SignupAnimationViewState extends State<SignupAnimationView> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadUserName();
      final anniversary = await LocalUserLocalDataSource.instance.getAnniversary();

      Timer(const Duration(milliseconds: 3700), () {
        if (mounted) {
          if (anniversary.isEmpty) {
            context.goNamed(ViewRoute.coupleAnniversary.name);
          } else {
            context.goNamed(ViewRoute.home.name);
          }
        }
      });
    } catch (e) {
      logger.e('Error in initialize: $e');
    }
  }

  Future<void> _loadUserName() async {
    try {
      var userEntity = await UserLocalDataSource.instance.getUser();
      if (userEntity != null && mounted) {
        setState(() {
          _userName = userEntity.name;
        });
      }
    } catch (e) {
      logger.e('Error loading user info: $e');
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
              _userName.isNotEmpty ? '$_userName님 반가워요' : '환영합니다!',
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