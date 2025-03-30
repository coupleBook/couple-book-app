class SplashState {
  final bool isInitialized;
  final bool hideSplash;
  final bool existToken;
  final bool existAnniversary;

  SplashState({
    this.isInitialized = false,
    this.hideSplash = false,
    this.existToken = false,
    this.existAnniversary = false,
  });

  SplashState copyWith({
    bool? isInitialized,
    bool? hideSplash,
    bool? existToken,
    bool? existAnniversary,
  }) {
    return SplashState(
      isInitialized: isInitialized ?? this.isInitialized,
      hideSplash: hideSplash ?? this.hideSplash,
      existToken: existToken ?? this.existToken,
      existAnniversary: existAnniversary ?? this.existAnniversary,
    );
  }
} 