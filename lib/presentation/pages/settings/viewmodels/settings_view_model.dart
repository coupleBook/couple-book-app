import 'dart:async';

import 'package:couple_book/data/local/datasources/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/datasources/last_login_local_data_source.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/data/repositories/couple_code_service.dart';
import 'package:couple_book/data/repositories/logout_service.dart';
import 'package:couple_book/presentation/pages/settings/models/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class SettingsViewModel extends StateNotifier<SettingsState> {
  final _logger = Logger();
  final LastLoginLocalDataSource _lastLoginLocalDataSource;
  final CoupleCodeLocalDataSource _coupleCodeLocalDataSource;
  final LogoutService _logoutService;
  final CoupleCodeService _coupleCodeService;

  Timer? _timer;

  SettingsViewModel({
    required LastLoginLocalDataSource lastLoginLocalDataSource,
    required CoupleCodeLocalDataSource coupleCodeLocalDataSource,
    required LogoutService logoutService,
    required CoupleCodeService coupleCodeService,
  })  : _lastLoginLocalDataSource = lastLoginLocalDataSource,
        _coupleCodeLocalDataSource = coupleCodeLocalDataSource,
        _logoutService = logoutService,
        _coupleCodeService = coupleCodeService,
        super(const SettingsState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadPlatform();
    await _loadCoupleCode();
  }

  Future<void> _loadPlatform() async {
    final loginEntity = await _lastLoginLocalDataSource.getLastLogin();
    state = state.copyWith(
      isPlatformLoaded: true,
      currentPlatform: loginEntity?.platform,
    );
  }

  Future<void> _loadCoupleCode() async {
    final coupleCodeEntity = await _coupleCodeLocalDataSource.getCoupleCode();

    if (coupleCodeEntity != null && coupleCodeEntity.isValid()) {
      state = state.copyWith(
        coupleCode: coupleCodeEntity.code,
        expirationTime: coupleCodeEntity.expirationAt,
      );
      _startTimer();
    } else {
      await _clearStoredData();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (state.expirationTime != null) {
        final diff = state.expirationTime!.difference(now);
        if (diff.isNegative) {
          state = state.copyWith(timeRemaining: '만료되었습니다. 재발급을 진행하세요.');
          _timer?.cancel();
          _clearStoredData();
        } else {
          state = state.copyWith(timeRemaining: _formatDuration(diff));
        }
      }
    });
  }

  Future<void> _clearStoredData() async {
    await _coupleCodeLocalDataSource.clearCoupleCode();
    state = state.copyWith(coupleCode: null, expirationTime: null);
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<bool> generateCoupleLinkCode() async {
    state = state.copyWith(isLoading: true);
    final response = await _coupleCodeService.generateCoupleLinkCode();
    state = state.copyWith(isLoading: false);

    if (response != null) {
      state = state.copyWith(
        coupleCode: response.code,
        expirationTime: response.expirationAt,
      );
      _startTimer();
      return true;
    }
    return false;
  }

  Future<CoupleCodeCreatorInfoResponseDto?> getCoupleLinkCode(String code) async {
    state = state.copyWith(isLoading: true);
    final response = await _coupleCodeService.getCoupleLinkCode(code);
    state = state.copyWith(isLoading: false);
    return response;
  }

  Future<String?> coupleLink(String code) async {
    state = state.copyWith(isLoading: true);
    final response = await _coupleCodeService.coupleLink(code);
    state = state.copyWith(isLoading: false);

    if (response == null) return '서버 응답 없음';
    if (response.status == 'FAILURE') return response.error?.message ?? '알 수 없는 오류';
    await _clearStoredData();
    return null;
  }

  Future<String?> logout() async {
    try {
      final platform = state.currentPlatform;
      if (platform != null) {
        await _logoutService.signOut(platform);
        return null;
      }
      return '플랫폼 정보 없음';
    } catch (e) {
      _logger.e('로그아웃 실패: $e');
      return '로그아웃 실패: $e';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
