import 'package:couple_book/feature01/domain/models/auth_model.dart';

class AuthState {
  final AuthModel? auth;
  final bool isLoading;
  final String? error;

  AuthState({
    this.auth,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthModel? auth,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      auth: auth ?? this.auth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
