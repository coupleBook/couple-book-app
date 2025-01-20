import 'package:couple_book/data/local/auth_local_data_source.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../api/user_api/user_profile_api.dart';
import '../../core/utils/security/couple_security.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../couple_anniversary/page.dart';
import '../home/page.dart';
import '../login/page.dart';

final logger = Logger();

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final userProfileApi = UserProfileApi();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  bool showTargetPage = false; // 대상 페이지 표시 여부
  bool hideSplash = false; // 스플래시 화면을 완전히 제거할지 여부
  bool existToken = false; // 토큰이 존재하는지 여부
  bool existAnniversary = false; // 기념일이 존재하는지 여부

  final AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();
  final LocalUserLocalDataSource localUserLocalDataSource =
      LocalUserLocalDataSource();

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
      final auth = await authLocalDataSource.getAuthInfo();
      final accessToken = auth?.accessToken ?? '';

      final anniversary = await localUserLocalDataSource.getAnniversary();

      logger.d("LOGIN TOKEN: $accessToken");
      logger.d("LOGIN TOKEN isNotEmpty: ${accessToken.isNotEmpty}");
      logger.d("ANNIVERSARY: $anniversary");
      logger.d("ANNIVERSARY isNotEmpty: ${anniversary.isNotEmpty}");

      if (accessToken.isNotEmpty) {
        var userProfile = await userProfileApi.getUserProfile();
        await setMyInfo(userProfile.me);
        if (userProfile.coupleInfo != null) {
          await setCoupleInfo(userProfile.coupleInfo!);
        }
        setState(() {
          existToken = true;
        });
      }

      if (anniversary.isNotEmpty) {
        setState(() {
          existAnniversary = true;
        });
      }

      _controller.forward().then((_) {
        setState(() {
          showTargetPage = true;
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

  /// -- access token이 존재하고 기념일이 존재하는 경우: HomePage
  /// -- access token이 존재하고 기념일이 존재하지 않는 경우: CoupleAnniversaryPage
  /// -- access token이 존재하지 않는 경우: LoginPage
  Widget _getTargetPage() {
    logger.d(
        '_getTargetPage: existToken: $existToken, existAnniversary: $existAnniversary');
    if (existToken && existAnniversary) {
      return const HomePage();
    } else if (existToken && !existAnniversary) {
      return const CoupleAnniversaryPage();
    } else {
      return const LoginPage();
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
          // 대상 페이지는 스플래시 화면이 사라지기 시작할 때부터 표시
          if (showTargetPage)
            Positioned.fill(
              child: _getTargetPage(),
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
