import 'package:couple_book/pages/couple_anniversary/page.dart';
import 'package:couple_book/pages/home/page.dart';
import 'package:couple_book/pages/login/page.dart';
import 'package:couple_book/pages/login/signup_animation.dart';
import 'package:couple_book/pages/logout/page.dart';
import 'package:couple_book/pages/splash/page.dart';
import 'package:couple_book/pages/test/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';

enum ViewRoute {
  splash,
  login,
  logout,
  home,
  coupleAnniversary,
  signupAnimation,
  testPage,
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
      case ViewRoute.testPage:
        return 'TEST_PAGE';
    }
  }
}

final router = GoRouter(
  navigatorKey: CoupleBookApp.navKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'SPLASH',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SplashView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/Login',
      name: 'LOGIN',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/Logout',
      name: 'LOGOUT',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LogoutPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/Home',
      name: 'HOME',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/couple-anniversary',
      name: 'COUPLE_ANNIVERSARY',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CoupleAnniversaryPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/signup-animation',
      name: 'SIGNUP_ANIMATION',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SignupAnimationPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/test',
      name: 'TEST_PAGE',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ApiTestPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
  ],
);
