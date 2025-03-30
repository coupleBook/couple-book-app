import 'package:couple_book/data/local/entities/enums/login_platform.dart';

class LoginState {
  final String? errorMessage;
  final LoginPlatform? currentPlatform;

  LoginState({
    this.errorMessage,
    this.currentPlatform,
  });

  LoginState copyWith({
    String? errorMessage,
    LoginPlatform? currentPlatform,
  }) {
    return LoginState(
      errorMessage: errorMessage ?? this.errorMessage,
      currentPlatform: currentPlatform ?? this.currentPlatform,
    );
  }
} 