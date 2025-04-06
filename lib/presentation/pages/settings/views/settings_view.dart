import 'package:couple_book/core/constants/l10n.dart';
import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/core/utils/snack_bar_util.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/presentation/pages/settings/viewmodels/settings_provider.dart';
import 'package:couple_book/presentation/pages/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    final platform = state.currentPlatform;
    final platformText = _getPlatformText(platform);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6D8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () => context.goNamed(ViewRoute.home.name),
                  ),
                  const Spacer(),
                  if (platformText != '')
                    GestureDetector(
                      onTap: () => _confirmLogout(context, viewModel, platform!),
                      child: Text(
                        platformText,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              _buildButton(
                title: '커플 연동 코드 생성',
                onPressed: () async {
                  final success = await viewModel.generateCoupleLinkCode();
                  if (!success && context.mounted) {
                    SnackBarUtil.show(context, '커플 연동 코드 생성 실패', type: SnackType.error);
                  }
                },
              ),
              _buildButton(
                title: '커플 연동 코드 조회',
                onPressed: () => _showInputDialog(context, '커플 연동 코드 조회', (code) async {
                  final info = await viewModel.getCoupleLinkCode(code);
                  if (context.mounted) {
                    if (info != null) {
                      _showCreatorInfoDialog(context, info);
                    } else {
                      SnackBarUtil.show(context, '커플 연동 코드 조회 실패', type: SnackType.error);
                    }
                  }
                }),
              ),
              _buildButton(
                title: '커플 연동하기',
                onPressed: () => _showInputDialog(context, '커플 연동하기', (code) async {
                  final result = await viewModel.coupleLink(code);
                  if (context.mounted) {
                    if (result == null) {
                      SnackBarUtil.show(context, '연동 성공', type: SnackType.success);
                    } else {
                      SnackBarUtil.show(context, result, type: SnackType.error);
                    }
                  }
                }),
              ),
              if (state.coupleCode != null) ...[
                const SizedBox(height: 30),
                const Text('생성된 커플 연동 코드', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SelectableText(state.coupleCode!, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 6),
                Text('남은 시간: ${state.timeRemaining}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }

  String _getPlatformText(LoginPlatform? platform) {
    switch (platform) {
      case LoginPlatform.naver:
        return l10n.logoutNaver;
      case LoginPlatform.google:
        return l10n.logoutGoogle;
      case null:
        return '';
    }
  }

  void _confirmLogout(BuildContext context, SettingsViewModel viewModel, LoginPlatform platform) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠어요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await viewModel.logout();
              if (context.mounted) {
                if (result == null) {
                  SnackBarUtil.show(context, '로그아웃 성공');
                  context.goNamed(ViewRoute.login.name);
                } else {
                  SnackBarUtil.show(context, result);
                }
              }
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  Future<void> _showInputDialog(BuildContext context, String title, Function(String) onSubmit) async {
    final TextEditingController textController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: '코드를 입력하세요'),
            autofocus: true,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                Navigator.of(context).pop();
                onSubmit(value);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final code = textController.text;
                if (code.isNotEmpty) {
                  Navigator.of(context).pop();
                  onSubmit(code);
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

  void _showCreatorInfoDialog(BuildContext context, CoupleCodeCreatorInfoResponseDto response) {
    final gender = Gender.fromServerValue(response.gender)?.toDisplayValue() ?? '미공개';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('커플 연동 코드 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름: ${response.username}'),
            Text('생일: ${response.birthday ?? '미공개'}'),
            Text('성별: $gender'),
            Text('기념일: ${response.datingAnniversary}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인')),
        ],
      ),
    );
  }
}
