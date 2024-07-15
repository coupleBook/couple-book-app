import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../router.dart';
import '../../style/text_style.dart';

/// 앱이 실행 될 때 노출되는 Splash 화면
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  int _currentImageIndex = 0;
  final List<Widget> _images = [
    Assets.icons.bgSplash01.svg(),
    Assets.icons.bgSplash03.svg(),
    Assets.icons.bgSplash02.svg(),
  ];

  /// 로그인 구현 되면 로직 변경
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      GoRouter.of(context).pushReplacementNamed('/Home');
    });
  }

  void _onImageTap() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onImageTap,
            child: Center(
              child: _images[_currentImageIndex],
            ),
          ),
          const Positioned(
            right: 0,
            left: 0,
            bottom: 62,
            child: AppText(
              "Copyright 2024. hyo_taes_ji all rights reserved.",
              style: TypoStyle.bodySmall,
              color: ColorName.fontGray,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
