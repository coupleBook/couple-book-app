import 'dart:async';

import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/datasources/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/datasources/last_login_local_data_source.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/data/repositories/couple_code_service.dart';
import 'package:couple_book/data/repositories/logout_service.dart';
import 'package:couple_book/presentation/pages/settings/models/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class SettingsViewModel extends ChangeNotifier {
  final Logger logger = Logger();
  final BuildContext context;
  final lastLoginLocalDataSource = LastLoginLocalDataSource();
  final coupleCodeLocalDataSource = CoupleCodeLocalDataSource.instance;
  final logoutService = LogoutService();
  late final CoupleCodeService coupleCodeService;

  Timer? _timer;
  SettingsState _state = const SettingsState();

  SettingsViewModel(this.context) {
    coupleCodeService = CoupleCodeService(context);
    _initialize();
  }

  SettingsState get state => _state;

  Future<void> _initialize() async {
    await _loadPlatform();
    await _loadCoupleCode();
  }

  Future<void> _loadPlatform() async {
    var lastLoginEntity = await lastLoginLocalDataSource.getLastLogin();
    _state = _state.copyWith(
      isPlatformLoaded: true,
      currentPlatform: lastLoginEntity?.platform,
    );
    notifyListeners();
  }

  Future<void> _loadCoupleCode() async {
    final coupleCodeEntity = await coupleCodeLocalDataSource.getCoupleCode();

    if (coupleCodeEntity != null) {
      if (coupleCodeEntity.isValid()) {
        _state = _state.copyWith(
          coupleCode: coupleCodeEntity.code,
          expirationTime: coupleCodeEntity.expirationAt,
        );
        _startTimer();
        notifyListeners();
      } else {
        await _clearStoredData();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_state.expirationTime != null) {
        final difference = _state.expirationTime!.difference(now);
        if (difference.isNegative) {
          _state = _state.copyWith(
            timeRemaining: '만료되었습니다. 재발급을 진행하세요.',
          );
          _timer?.cancel();
          _clearStoredData();
        } else {
          _state = _state.copyWith(
            timeRemaining: _formatDuration(difference),
          );
        }
        notifyListeners();
      }
    });
  }

  Future<void> _clearStoredData() async {
    await coupleCodeLocalDataSource.clearCoupleCode();
    _state = _state.copyWith(
      coupleCode: null,
      expirationTime: null,
    );
    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> generateCoupleLinkCode() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final response = await coupleCodeService.generateCoupleLinkCode();
    if (response != null) {
      _state = _state.copyWith(
        coupleCode: response.code,
        expirationTime: response.expirationAt,
        isLoading: false,
      );
      _startTimer();
      notifyListeners();
    }
  }

  Future<void> getCoupleLinkCode(String coupleCode) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final response = await coupleCodeService.getCoupleLinkCode(coupleCode);
    if (response != null) {
      _showCreatorInfo(response);
    }
    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  void _showCreatorInfo(CoupleCodeCreatorInfoResponseDto response) {
    final username = response.username;
    final birthday = response.birthday ?? '미공개';
    final gender = Gender.fromServerValue(response.gender)?.toDisplayValue() ?? '미공개';
    final datingAnniversary = response.datingAnniversary;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('커플 연동 코드 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름: $username'),
              Text('생일: $birthday'),
              Text('성별: $gender'),
              Text('기념일: $datingAnniversary'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> coupleLink(
      String coupleCode, {
        required void Function(String message) onError,
        required VoidCallback onSuccess,
      }) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final response = await coupleCodeService.coupleLink(coupleCode);

    _state = _state.copyWith(isLoading: false);
    notifyListeners();

    if (response == null) return;

    if (response.status == 'FAILURE') {
      final errorMessage = response.error?.message ?? '알 수 없는 오류가 발생했습니다.';
      onError(errorMessage);
      return;
    }

    await _clearStoredData();
    onSuccess();
  }

  Future<void> handleLogout(LoginPlatform platform) async {
    try {
      await logoutService.signOut(platform);
      if (context.mounted) {
        _showSnackBar('로그아웃 성공');
        _navigateToLogin();
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar('로그아웃 실패: $e');
        logger.e('로그아웃 오류: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToLogin() {
    context.goNamed(ViewRoute.login.name);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
