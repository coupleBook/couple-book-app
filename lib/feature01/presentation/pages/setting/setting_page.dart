import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/feature01/viewmodels/logout_controller.dart';
import 'package:couple_book/feature01/viewmodels/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../api/couple_api/couple_code_creator_info_response.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  late final LogoutController _logoutController;
  bool isPlatformLoaded = false;

  @override
  void initState() {
    super.initState();
    _logoutController = LogoutController(context);
    _initPlatform();
  }

  Future<void> _initPlatform() async {
    await _logoutController.loadCurrentPlatform();
    if (mounted) {
      setState(() => isPlatformLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingState = ref.watch(settingProvider);
    final settingNotifier = ref.read(settingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogoutButton(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: settingNotifier.generateCoupleCode,
              child: const Text('커플 연동 코드 생성'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showInputDialog('커플 연동 코드 조회', (code) async {
                  final userInfo = await settingNotifier.getCoupleInfo(code);
                  if (userInfo != null) {
                    _showPopup(userInfo);
                  }
                });
              },
              child: const Text('커플 연동 코드 조회'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showInputDialog('커플 연동하기', (code) {
                  settingNotifier.coupleLink(code);
                });
              },
              child: const Text('커플 연동하기'),
            ),
            const SizedBox(height: 20),
            if (settingState.coupleCode != null)
              Column(
                children: [
                  const Text('생성된 커플 연동 코드:'),
                  const SizedBox(height: 10),
                  SelectableText(
                    settingState.coupleCode!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text('남은 시간: ${settingState.timeRemaining}'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed(ViewRoute.home.name),
              child: const Text('홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final platform = _logoutController.currentPlatform;

    if (!isPlatformLoaded) {
      return const CircularProgressIndicator();
    }

    if (platform == null) {
      return const Text('플랫폼 정보 없음');
    }

    late final String buttonText;
    late final VoidCallback onPressed;

    switch (platform) {
      case LoginPlatform.naver:
        buttonText = l10n.logoutNaver;
        onPressed = () => _logoutController.handleLogout(LoginPlatform.naver);
        break;
      case LoginPlatform.google:
        buttonText = l10n.logoutGoogle;
        onPressed = () => _logoutController.handleLogout(LoginPlatform.google);
        break;
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  void _showInputDialog(String title, Function(String) onSubmit) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '코드를 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onSubmit(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _showPopup(CoupleCodeCreatorInfoResponseDto userInfo) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('커플 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('코드: ${userInfo.code}'),
              const SizedBox(height: 6),
              Text('이름: ${userInfo.username}'),
              if (userInfo.birthday != null) ...[
                const SizedBox(height: 6),
                Text('생일: ${userInfo.birthday}'),
              ],
              if (userInfo.gender != null) ...[
                const SizedBox(height: 6),
                Text('성별: ${userInfo.gender}'),
              ],
              const SizedBox(height: 6),
              Text('기념일: ${userInfo.datingAnniversary}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
