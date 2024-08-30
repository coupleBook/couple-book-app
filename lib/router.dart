import 'package:couple_book/pages/home/page.dart';
import 'package:couple_book/pages/login/page.dart';
import 'package:couple_book/pages/splash/page.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

enum ViewRoute {
  splash,
  login,
  home,
}

extension RouteString on ViewRoute {
  String get name {
    switch (this) {
      case ViewRoute.splash:
        return 'SPLASH';
      case ViewRoute.login:
        return 'LOGIN';
      case ViewRoute.home:
        return 'HOME';
    }
  }
}

final router = GoRouter(
  navigatorKey: CoupleBookApp.navKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'SPLASH',
      builder: (context, state) {
        return const SplashView();
      },
    ),

    GoRoute(
      path: '/Login',
      name: 'LOGIN',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/Home',
      name: 'HOME',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
