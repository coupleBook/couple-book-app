import 'package:couple_book/data/local/entities/enums/login_platform.dart';

class SettingsState {
  final bool isPlatformLoaded;
  final LoginPlatform? currentPlatform;
  final String? coupleCode;
  final DateTime? expirationTime;
  final String timeRemaining;
  final bool isLoading;

  const SettingsState({
    this.isPlatformLoaded = false,
    this.currentPlatform,
    this.coupleCode,
    this.expirationTime,
    this.timeRemaining = '',
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isPlatformLoaded,
    LoginPlatform? currentPlatform,
    String? coupleCode,
    DateTime? expirationTime,
    String? timeRemaining,
    bool? isLoading,
  }) {
    return SettingsState(
      isPlatformLoaded: isPlatformLoaded ?? this.isPlatformLoaded,
      currentPlatform: currentPlatform ?? this.currentPlatform,
      coupleCode: coupleCode ?? this.coupleCode,
      expirationTime: expirationTime ?? this.expirationTime,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
