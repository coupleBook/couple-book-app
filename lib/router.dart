import 'package:COUPLE_BOOK/pages/home/page.dart';
import 'package:COUPLE_BOOK/pages/splash/page.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

final router = GoRouter(
  navigatorKey: CoupleBookApp.navKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashView();
      },
    ),

    GoRoute(
      path: '/Home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
