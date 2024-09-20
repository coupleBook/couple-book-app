import 'package:couple_book/pages/couple_anniversary/page.dart';
import 'package:couple_book/pages/home/page.dart';
import 'package:couple_book/pages/login/page.dart';
import 'package:couple_book/pages/login/signup_animation.dart';
import 'package:couple_book/pages/logout/page.dart';
import 'package:couple_book/pages/splash/page.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

enum ViewRoute {
  splash,
  login,
  logout,
  home,
  coupleAnniversary,
  signupAnimation,
}

extension RouteString on ViewRoute {
  String get name {
    switch (this) {
      case ViewRoute.splash:
        return 'SPLASH';
      case ViewRoute.login:
        return 'LOGIN';
      case ViewRoute.logout:
        return 'LOGOUT';
      case ViewRoute.home:
        return 'HOME';
      case ViewRoute.coupleAnniversary:
        return 'COUPLE_ANNIVERSARY';
      case ViewRoute.signupAnimation:
        return 'SIGNUP_ANIMATION';
    }
  }
}

final router = GoRouter(
  navigatorKey: CoupleBookApp.navKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'SPLASH',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/Login',
      name: 'LOGIN',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/Logout',
      name: 'LOGOUT',
      builder: (context, state) => const LogoutPage(),
    ),
    GoRoute(
      path: '/Home',
      name: 'HOME',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/couple-anniversary',
      name: 'COUPLE_ANNIVERSARY',
      builder: (context, state) =>
          const CoupleAnniversaryPage(), // CoupleAnniversaryPage 클래스 이름은 실제 파일에 맞게 조정하세요
    ),
    GoRoute(
      path: '/signup-animation',
      name: 'SIGNUP_ANIMATION',
      builder: (context, state) => const SignupAnimationPage(),
    ),
  ],
);
