class SplashState {
  final bool showTargetPage;
  final bool hideSplash;
  final bool existToken;
  final bool existAnniversary;

  SplashState({
    this.showTargetPage = false,
    this.hideSplash = false,
    this.existToken = false,
    this.existAnniversary = false,
  });

  SplashState copyWith({
    bool? showTargetPage,
    bool? hideSplash,
    bool? existToken,
    bool? existAnniversary,
  }) {
    return SplashState(
      showTargetPage: showTargetPage ?? this.showTargetPage,
      hideSplash: hideSplash ?? this.hideSplash,
      existToken: existToken ?? this.existToken,
      existAnniversary: existAnniversary ?? this.existAnniversary,
    );
  }
} 