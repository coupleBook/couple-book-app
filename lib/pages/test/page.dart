import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../router.dart';
import '../../utils/constants/login_platform.dart';
import 'couple_controller.dart';
import 'logout_controller.dart';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestViewState();
}

class _ApiTestViewState extends State<ApiTestPage> {
  late LogoutController _logoutController;
  late CoupleController _coupleController;
  bool isPlatformLoaded = false;

  String? coupleCode; // 커플 연동 코드 저장 변수
  DateTime? expirationTime; // 만료 시간 저장 변수
  Timer? _timer;
  String timeRemaining = ''; // 남은 시간 표시용 변수
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _logoutController = LogoutController(context);
    _coupleController = CoupleController(context);
    _loadPlatform(); // 로그아웃 시 플랫폼 로드
    _loadCoupleCode(); // 페이지에 들어올 때 저장된 커플 코드 로드
  }

  Future<void> _loadPlatform() async {
    await _logoutController.loadCurrentPlatform();
    setState(() {
      isPlatformLoaded = true; // 플랫폼 로드 완료
    });
  }

  Future<void> _loadCoupleCode() async {
    // 저장된 커플 코드와 만료 시간 로드
    final storedCode = await secureStorage.read(key: 'coupleCode');
    final storedExpiration = await secureStorage.read(key: 'expirationTime');

    if (storedCode != null && storedExpiration != null) {
      final expiration = DateTime.parse(storedExpiration);
      final now = DateTime.now();

      if (expiration.isAfter(now)) {
        setState(() {
          coupleCode = storedCode;
          expirationTime = expiration;
        });
        _startTimer();
      } else {
        // 만료된 데이터 삭제
        await _clearStoredData();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (expirationTime != null) {
        final difference = expirationTime!.difference(now);
        if (difference.isNegative) {
          setState(() {
            timeRemaining = '만료되었습니다. 재발급을 진행하세요.';
            _timer?.cancel();
            _clearStoredData();
          });
        } else {
          setState(() {
            timeRemaining = _formatDuration(difference);
          });
        }
      }
    });
  }

  Future<void> _clearStoredData() async {
    await secureStorage.delete(key: 'coupleCode');
    await secureStorage.delete(key: 'expirationTime');
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _generateCoupleLinkCode() async {
    final response = await _coupleController.generateCoupleLinkCode();
    if (response != null) {
      setState(() {
        coupleCode = response.code; // 커플 연동 코드 저장
        expirationTime = DateTime.now().add(
          Duration(seconds: response.expirationTimeInSeconds),
        ); // 만료 시간 설정
      });
      await secureStorage.write(key: 'coupleCode', value: coupleCode);
      await secureStorage.write(
          key: 'expirationTime', value: expirationTime.toString());
      _startTimer(); // 타이머 시작
    }
  }

  Future<void> _coupleLink(String coupleCode) async {
    final response = await _coupleController.coupleLink(coupleCode);
    if (response != null) {
      setState(() {
        // TODO: 커플 연동 성공 시 처리 (파트너 response 활용)
        _clearStoredData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API 테스트용 페이지"), // 상단 제목
      ),
      body: isPlatformLoaded
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoutButton(), // 로그아웃 버튼
                  const SizedBox(height: 20), // 간격 추가
                  ElevatedButton(
                    onPressed: _generateCoupleLinkCode,
                    child: const Text('커플 연동 코드 생성'),
                  ),
                  const SizedBox(height: 10), // 간격 추가
                  ElevatedButton(
                    onPressed: () {
                      _showInputDialog('커플 연동 코드 조회', (coupleCode) {
                        _coupleController.getCoupleLinkCode(coupleCode);
                      });
                    },
                    child: const Text('커플 연동 코드 조회'),
                  ),
                  const SizedBox(height: 10), // 간격 추가
                  ElevatedButton(
                    onPressed: () {
                      _showInputDialog('커플 연동하기', (coupleCode) {
                        _coupleLink(coupleCode);
                      });
                    },
                    child: const Text('커플 연동하기'),
                  ),
                  const SizedBox(height: 20),
                  if (coupleCode != null)
                    Column(
                      children: [
                        const Text('생성된 커플 연동 코드:'),
                        const SizedBox(height: 10),
                        SelectableText(
                          coupleCode!, // 선택 가능한 텍스트로 커플 코드 표시
                          style: const TextStyle(fontSize: 18),
                          showCursor: true,
                          cursorColor: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Text('남은 시간: $timeRemaining'),
                      ],
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(ViewRoute.home.name);
                    },
                    child: const Text('뒤로가기'),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildLogoutButton() {
    if (_logoutController.currentPlatform == null) {
      return const CircularProgressIndicator();
    }

    String buttonText;
    Function() onPressed;

    if (_logoutController.currentPlatform == LoginPlatform.naver) {
      buttonText = l10n.logoutNaver;
      onPressed = () => _logoutController.handleLogout(LoginPlatform.naver);
    } else if (_logoutController.currentPlatform == LoginPlatform.google) {
      buttonText = l10n.logoutGoogle;
      onPressed = () => _logoutController.handleLogout(LoginPlatform.google);
    } else {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  Future<void> _showInputDialog(String title, Function(String) onSubmit) async {
    final TextEditingController textController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: '코드를 입력하세요'),
            autofocus: true,
            enableInteractiveSelection: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final code = textController.text;
                if (code.isNotEmpty) {
                  onSubmit(code);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
