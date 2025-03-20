import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/feature01/presentation/pages/home/widget/main_dday.dart';
import 'package:couple_book/feature01/presentation/viewmodels/home_provider.dart';
import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/pages/home/widget/home_app_bar.dart';
import 'package:couple_book/pages/timeline/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    final List<Widget> widgetOptions = <Widget>[
      const MainDdayView(),
      _buildPlaceholder(),
      const TimelinePage(),
      _buildPlaceholder(),
      _buildPlaceholder(),
    ];

    return Scaffold(
      appBar: HomeAppBar(
        onNotificationTab: () => {},
        onSettingTab: () => {},
      ),
      body: widgetOptions.elementAt(homeState.selectedIndex),
      backgroundColor: ColorName.backgroundColor,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: ColorName.defaultGray),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontFamily: 'Iseoyunchae',
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: ColorName.defaultGray,
                ),
              ),
            ),
            child: NavigationBar(
              elevation: 5,
              backgroundColor: ColorName.backgroundColor,
              surfaceTintColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              selectedIndex: homeState.selectedIndex,
              onDestinationSelected: homeNotifier.updateIndex,
              destinations: [
                NavigationDestination(
                  selectedIcon: Assets.icons.homeIcon_on.svg(width: 24, height: 24),
                  icon: Assets.icons.homeIcon_off.svg(width: 24, height: 24),
                  label: l10n.home,
                ),
                NavigationDestination(
                  selectedIcon: Assets.icons.coupleInfo_on.svg(width: 24, height: 24),
                  icon: Assets.icons.coupleInfo_off.svg(width: 24, height: 24),
                  label: l10n.coupleInfo,
                ),
                NavigationDestination(
                  selectedIcon: Assets.icons.timelineIcon_on.svg(width: 24, height: 24),
                  icon: Assets.icons.timelineIcon_off.svg(width: 24, height: 24),
                  label: l10n.timeline,
                ),
                NavigationDestination(
                  selectedIcon: Assets.icons.challengeIcon_on.svg(width: 20, height: 20),
                  icon: Assets.icons.challengeIcon_off.svg(width: 20, height: 20),
                  label: l10n.challenge,
                ),
                NavigationDestination(
                  selectedIcon: Assets.icons.moreIcon_on.svg(width: 10, height: 10),
                  icon: Assets.icons.moreIcon_off.svg(width: 10, height: 10),
                  label: l10n.more,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 준비 중인 페이지를 표시하는 Placeholder
  static Widget _buildPlaceholder() {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -3),
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    );
  }
}
