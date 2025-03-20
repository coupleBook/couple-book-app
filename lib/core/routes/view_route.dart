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

  String get path {
    switch (this) {
      case ViewRoute.splash:
        return '/';
      case ViewRoute.login:
        return '/login';
      case ViewRoute.logout:
        return '/logout';
      case ViewRoute.home:
        return '/home';
      case ViewRoute.coupleAnniversary:
        return '/couple-anniversary';
      case ViewRoute.signupAnimation:
        return '/signup-animation';
      case ViewRoute.testPage:
        return '/test';
    }
  }
}
