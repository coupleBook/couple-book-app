import 'dart:async';

import 'package:couple_book/api/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/api/couple_api/couple_linking_response_dto.dart';
import 'package:couple_book/data/local/couple_code_local_data_source.dart';
import 'package:couple_book/feature01/services/couple_code_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingViewModel extends StateNotifier<SettingState> {
  final CoupleCodeService _coupleCodeService;
  final CoupleCodeLocalDataSource _coupleCodeLocal = CoupleCodeLocalDataSource.instance;

  Timer? _timer;

  SettingViewModel(this._coupleCodeService) : super(SettingState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    _loadCoupleCode();
  }

  Future<void> _loadCoupleCode() async {
    final codeEntity = await _coupleCodeLocal.getCoupleCode();
    if (codeEntity != null && codeEntity.isValid()) {
      state = state.copyWith(
        coupleCode: codeEntity.code,
        expirationTime: codeEntity.expirationAt,
      );
      _startTimer();
    } else {
      _clearStoredData();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final expiration = state.expirationTime;
      if (expiration != null) {
        final diff = expiration.difference(now);
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

  String _formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> generateCoupleCode() async {
    final entity = await _coupleCodeService.generateCoupleLinkCode();
    if (entity != null) {
      state = state.copyWith(
        coupleCode: entity.code,
        expirationTime: entity.expirationAt,
      );
      _startTimer();
    }
  }

  Future<CoupleCodeCreatorInfoResponseDto?> getCoupleInfo(String code) {
    return _coupleCodeService.getCoupleLinkCode(code);
  }

  Future<CoupleLinkingResponseDto?> coupleLink(String code) {
    return _coupleCodeService.coupleLink(code);
  }

  Future<void> _clearStoredData() async {
    await _coupleCodeLocal.clearCoupleCode();
    state = state.copyWith(coupleCode: null, expirationTime: null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SettingState {
  final String? coupleCode;
  final DateTime? expirationTime;
  final String timeRemaining;

  SettingState({
    this.coupleCode,
    this.expirationTime,
    this.timeRemaining = '',
  });

  SettingState copyWith({
    String? coupleCode,
    DateTime? expirationTime,
    String? timeRemaining,
  }) {
    return SettingState(
      coupleCode: coupleCode ?? this.coupleCode,
      expirationTime: expirationTime ?? this.expirationTime,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}

final settingProvider = StateNotifierProvider<SettingViewModel, SettingState>((ref) {
  return SettingViewModel(CoupleCodeService());
});
