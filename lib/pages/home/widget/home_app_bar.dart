import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onNotificationTab;
  final void Function() onSettingTab;

  const HomeAppBar({
    super.key,
    required this.onNotificationTab,
    required this.onSettingTab
  });


  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(60),
              highlightColor: ColorName.lightGray,
              onTap: onNotificationTab,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Assets.icons.noticeIcon_n.svg(
                  width: 33,
                  height: 28
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(60),
              highlightColor: ColorName.lightGray,
              onTap: onSettingTab,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Assets.icons.settingIcon_n.svg(
                  width: 32,
                  height: 32
                ),
              ),
            ),
          ),
        ),
      ],
      centerTitle: true,
      backgroundColor: ColorName.backgroundColor,
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(70);
}