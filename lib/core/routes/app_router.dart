import 'package:couple_book/feature01/presentation/pages/home/home_page.dart';
import 'package:couple_book/feature01/presentation/pages/login_page.dart';
import 'package:couple_book/feature01/presentation/pages/setting/setting_page.dart';
import 'package:couple_book/feature01/presentation/pages/signup_animation_page.dart';
import 'package:couple_book/feature01/presentation/pages/splash_page.dart';
import 'package:couple_book/main.dart';
import 'package:couple_book/feature01/presentation/pages/couple_anniversary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'view_route.dart';

class AppRouter extends Notifier<GoRouter> {
  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: CoupleBookApp.navKey,
      initialLocation: ViewRoute.splash.path,
      routes: _routes,
    );
  }

  static final List<GoRoute> _routes = [
    _buildRoute(ViewRoute.splash, const SplashPage()),
    _buildRoute(ViewRoute.login, const LoginPage()),
    _buildRoute(ViewRoute.home, const HomePage()),
    _buildRoute(ViewRoute.coupleAnniversary, const CoupleAnniversaryPage()),
    _buildRoute(ViewRoute.signupAnimation, const SignupAnimationPage()),
    _buildRoute(ViewRoute.testPage, const SettingPage()),
  ];

  static GoRoute _buildRoute(ViewRoute route, Widget child) {
    return GoRoute(
      path: route.path,
      name: route.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
