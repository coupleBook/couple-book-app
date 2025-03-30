import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/presentation/pages/splash/models/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SplashViewModel extends ChangeNotifier {
  final AuthLocalDataSource _authLocalDataSource;
  final LocalUserLocalDataSource _localUserLocalDataSource;
  SplashState _state;

  SplashViewModel({
    required AuthLocalDataSource authLocalDataSource,
    required LocalUserLocalDataSource localUserLocalDataSource,
  })  : _authLocalDataSource = authLocalDataSource,
        _localUserLocalDataSource = localUserLocalDataSource,
        _state = SplashState() {
    _initialize();
  }

  SplashState get state => _state;

  Future<void> _initialize() async {
    try {
      final authInfo = await _authLocalDataSource.getAuthInfo();
      final anniversary = await _localUserLocalDataSource.getAnniversary();

      _state = _state.copyWith(
        isInitialized: true,
        hideSplash: true,
        existToken: authInfo?.accessToken != null && authInfo!.accessToken.isNotEmpty,
        existAnniversary: anniversary.isNotEmpty,
      );
      notifyListeners();
    } catch (e) {
      logger.e('Failed to initialize splash screen: $e');
      _state = _state.copyWith(
        isInitialized: true,
        hideSplash: true,
        existToken: false,
        existAnniversary: false,
      );
      notifyListeners();
    }
  }
}
