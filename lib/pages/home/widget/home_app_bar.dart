import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/l10n.dart';
import '../../../core/constants/assets.gen.dart';
import '../../../core/theme/colors.gen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onNotificationTab;
  final void Function() onSettingTab;

  const HomeAppBar({
    super.key,
    required this.onNotificationTab,
    required this.onSettingTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 11),
              child: AppText(
                l10n.appName,
                style: TypoStyle.notoSansBold22,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    highlightColor: ColorName.lightGray,
                    onTap: onNotificationTab,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Assets.icons.noticeIcon_n.svg(
                        width: 29,
                        height: 24,
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
                    onTap: () {
                      context.goNamed(ViewRoute.testPage.name);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Assets.icons.settingIcon_n.svg(
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: false,
            backgroundColor: ColorName.backgroundColor,
            elevation: 0, // AppBar의 그림자를 없앰
          ),
          // AppBar 아래에 라인을 추가합니다.
          Container(
            margin: const EdgeInsets.only(top: 20), // 라인의 위치를 더 아래로 내립니다.
            color: ColorName.defaultGray, // 라인의 색상
            height: 1.0, // 라인의 두께
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90); // 높이를 조정하여 AppBar와 라인의 전체 크기를 설정합니다.
}
