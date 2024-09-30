import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../api/session.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../utils/security/auth_security.dart';
import '../login/page.dart';


final logger = Logger();
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool showLoginPage = false; // 로그인 페이지 표시 여부 결정
  bool hideSplash = false; // 스플래시 화면을 완전히 제거할지 여부
  bool existToken = false; // 토큰이 존재하는지 여부

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    try {
      final accessToken = await getAccessToken();
      Session.accessToken = accessToken;

      if (Session.accessToken.isNotEmpty) {
        setState(() {
          existToken = true;
        });
      }


      _controller.forward().then((_) {
        setState(() {
          showLoginPage = true;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          _controller.reverse().then((_) {
            setState(() {
              hideSplash = true;
            });
          });
        });
      });
    } catch (e) {
      logger.d("Error during splash initialization: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // LoginPage는 스플래시 화면이 사라지기 시작할 때부터 표시
          if (showLoginPage)
            const Positioned.fill(
              child: LoginPage(),
            ),
          // 스플래시 화면: hideSplash가 false일 때만 표시
          if (!hideSplash)
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                color: ColorName.backgroundColor,
                child: Center(
                  child: Assets.icons.appLogoIcon.svg(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
