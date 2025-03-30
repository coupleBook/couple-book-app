import 'package:couple_book/core/constants/l10n.dart';
import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/presentation/pages/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("설정"),
        ),
        body: Consumer<SettingsViewModel>(
          builder: (context, viewModel, child) {
            if (!viewModel.state.isPlatformLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoutButton(viewModel),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: viewModel.generateCoupleLinkCode,
                    child: const Text('커플 연동 코드 생성'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showInputDialog('커플 연동 코드 조회', (coupleCode) {
                        viewModel.getCoupleLinkCode(coupleCode);
                      });
                    },
                    child: const Text('커플 연동 코드 조회'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showInputDialog('커플 연동하기', (coupleCode) {
                        viewModel.coupleLink(
                          coupleCode,
                          onError: (message) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('에러'),
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('커플 연동 성공!')),
                            );
                          },
                        );
                      });
                    },
                    child: const Text('커플 연동하기'),
                  ),
                  const SizedBox(height: 20),
                  if (viewModel.state.coupleCode != null)
                    Column(
                      children: [
                        const Text('생성된 커플 연동 코드:'),
                        const SizedBox(height: 10),
                        SelectableText(
                          viewModel.state.coupleCode!,
                          style: const TextStyle(fontSize: 18),
                          showCursor: true,
                          cursorColor: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Text('남은 시간: ${viewModel.state.timeRemaining}'),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton(SettingsViewModel viewModel) {
    if (viewModel.state.currentPlatform == null) {
      return const CircularProgressIndicator();
    }

    String buttonText;
    Function() onPressed;

    if (viewModel.state.currentPlatform == LoginPlatform.naver) {
      buttonText = l10n.logoutNaver;
      onPressed = () => viewModel.handleLogout(LoginPlatform.naver);
    } else if (viewModel.state.currentPlatform == LoginPlatform.google) {
      buttonText = l10n.logoutGoogle;
      onPressed = () => viewModel.handleLogout(LoginPlatform.google);
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
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onSubmit(value);
                Navigator.of(context).pop();
              }
            },
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
