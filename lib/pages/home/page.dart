import 'package:COUPLE_BOOK/gen/colors.gen.dart';
import 'package:COUPLE_BOOK/pages/home/widget/home_app_bar.dart';
import 'package:flutter/material.dart';

import '../../style/text_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onNotificationTab: () => {},
        onSettingTab: () => {},
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
      backgroundColor: ColorName.backgroundColor,
    );
  }
}
