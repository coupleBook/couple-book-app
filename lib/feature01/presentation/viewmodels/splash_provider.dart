import 'package:couple_book/core/providers/data_providers.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/feature01/data/local/auth_local_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier(
    ref.watch(authLocalDataSourceProvider),
    ref.watch(localUserLocalDataSourceProvider),
  );
});

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

class SplashNotifier extends StateNotifier<SplashState> {
  final AuthLocalDataSource authLocalDataSource;
  final LocalUserLocalDataSource localUserLocalDataSource;

  SplashNotifier(this.authLocalDataSource, this.localUserLocalDataSource) : super(SplashState()) {
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    try {
      final accessToken = (await authLocalDataSource.getAuthInfo())?.accessToken ?? '';
      final anniversary = await localUserLocalDataSource.getAnniversary();

      state = state.copyWith(
        existToken: accessToken.isNotEmpty,
        existAnniversary: anniversary.isNotEmpty,
      );
    } catch (e) {
      logger.e("Error during splash initialization: $e");
    }
  }
}
