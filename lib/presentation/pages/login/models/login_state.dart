import 'package:couple_book/data/local/entities/enums/login_platform.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final LoginPlatform? currentPlatform;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.currentPlatform,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    LoginPlatform? currentPlatform,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPlatform: currentPlatform ?? this.currentPlatform,
    );
  }
} 