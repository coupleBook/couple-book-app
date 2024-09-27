import 'package:flutter/material.dart';
import '../../api/session.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../utils/security/auth_security.dart';
import '../login/page.dart';

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
  bool existToken = false;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    /// TODO: 로그인 토큰만 체크 하지만 처음 만난날이 설정 되어있는지도 체크해서 홈, 처음만난날 페이지 이동 분기 처리 해야함
    final accessToken = await getAccessToken();
    Session.accessToken = accessToken;

    if(Session.accessToken.isNotEmpty) {
      existToken = true;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 애니메업이션 지속 시간
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      setState(() {
        showLoginPage = true; // 로그인 페이지 표시 시작
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.reverse().then((_) {
          // 애니메이션이 완료되면 스플래시 화면을 제거
          setState(() {
            hideSplash = true;
          });
        });
      });
    });
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
