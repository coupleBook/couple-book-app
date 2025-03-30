import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/constants/l10n.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/presentation/pages/home/viewmodels/home_view_model.dart';
import 'package:couple_book/presentation/pages/home/widgets/home_app_bar.dart';
import 'package:couple_book/presentation/pages/home/widgets/main_dday.dart';
import 'package:couple_book/presentation/pages/timeline/views/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
  }

  // 각 탭에서 표시할 위젯들을 정의
  late final List<Widget> _widgetOptions = <Widget>[
    const MainDdayView(), // Home 버튼에서 MainDdayView를 표시
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3),
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
    const TimelineView(),
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3),
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3),
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: HomeAppBar(
              onNotificationTab: viewModel.onNotificationTab,
              onSettingTab: viewModel.onSettingTab,
            ),
            body: _widgetOptions.elementAt(viewModel.state.selectedIndex),
            backgroundColor: ColorName.backgroundColor,
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  color: ColorName.defaultGray,
                ),
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
                    selectedIndex: viewModel.state.selectedIndex,
                    onDestinationSelected: viewModel.setSelectedIndex,
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
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
} 