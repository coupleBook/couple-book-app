import 'package:couple_book/data/local/entities/enums/login_platform.dart';

class SettingState {
  final bool isPlatformLoaded;
  final LoginPlatform? currentPlatform;
  final String? coupleCode;
  final DateTime? expirationTime;
  final String timeRemaining;

  const SettingState({
    required this.isPlatformLoaded,
    this.currentPlatform,
    this.coupleCode,
    this.expirationTime,
    this.timeRemaining = '',
  });

  SettingState copyWith({
    bool? isPlatformLoaded,
    LoginPlatform? currentPlatform,
    String? coupleCode,
    DateTime? expirationTime,
    String? timeRemaining,
  }) {
    return SettingState(
      isPlatformLoaded: isPlatformLoaded ?? this.isPlatformLoaded,
      currentPlatform: currentPlatform ?? this.currentPlatform,
      coupleCode: coupleCode ?? this.coupleCode,
      expirationTime: expirationTime ?? this.expirationTime,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }

  factory SettingState.initial() {
    return const SettingState(
      isPlatformLoaded: false,
      coupleCode: null,
      expirationTime: null,
      timeRemaining: '',
    );
  }
}
