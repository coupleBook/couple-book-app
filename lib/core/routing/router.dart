import 'package:couple_book/main.dart';
import 'package:couple_book/presentation/pages/couple_anniversary/views/couple_anniversary_view.dart';
import 'package:couple_book/presentation/pages/home/views/home_view.dart';
import 'package:couple_book/presentation/pages/login/views/login_view.dart';
import 'package:couple_book/presentation/pages/settings/views/settings_view.dart';
import 'package:couple_book/presentation/pages/signup_animation/views/signup_animation_view.dart';
import 'package:couple_book/presentation/pages/splash/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ViewRoute {
  splash,
  login,
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
          child: const LoginView(),
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
          child: const HomeView(),
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
          child: const CoupleAnniversaryView(),
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
          child: const SignupAnimationView(),
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
          child: const SettingsView(),
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
