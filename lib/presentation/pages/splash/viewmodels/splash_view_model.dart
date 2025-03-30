import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/presentation/pages/splash/models/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SplashViewModel extends ChangeNotifier {
  final AuthLocalDataSource _authLocalDataSource;
  final LocalUserLocalDataSource _localUserLocalDataSource;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  SplashState _state;

  SplashViewModel({
    required AuthLocalDataSource authLocalDataSource,
    required LocalUserLocalDataSource localUserLocalDataSource,
    required TickerProvider vsync,
  })  : _authLocalDataSource = authLocalDataSource,
        _localUserLocalDataSource = localUserLocalDataSource,
        _state = SplashState() {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _initializeSplash();
  }

  SplashState get state => _state;

  double get opacity => _opacityAnimation.value;

  Future<void> _initializeSplash() async {
    try {
      final accessToken = (await _authLocalDataSource.getAuthInfo())?.accessToken ?? '';
      final anniversary = await _localUserLocalDataSource.getAnniversary();

      logger.d("LOGIN TOKEN: $accessToken");
      logger.d("LOGIN TOKEN isNotEmpty: ${accessToken.isNotEmpty}");
      logger.d("ANNIVERSARY: $anniversary");
      logger.d("ANNIVERSARY isNotEmpty: ${anniversary.isNotEmpty}");

      _state = _state.copyWith(
        existToken: accessToken.isNotEmpty,
        existAnniversary: anniversary.isNotEmpty,
      );
      notifyListeners();

      _controller.forward().then((_) {
        _state = _state.copyWith(showTargetPage: true);
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 500), () {
          _controller.reverse().then((_) {
            _state = _state.copyWith(hideSplash: true);
            notifyListeners();
          });
        });
      });
    } catch (e) {
      logger.e("Error in _initializeSplash: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
