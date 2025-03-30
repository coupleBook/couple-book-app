// HomePage.dart

import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/pages/home/widget/home_app_bar.dart';
import 'package:couple_book/pages/home/widget/main_dday.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couple_book/core/constants/l10n.dart';
import '../../core/constants/assets.gen.dart';
import '../timeline/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late SharedPreferences prefs;
  String? anniversaryDate;

  @override
  void initState() {
    super.initState();
  }

  // 각 탭에서 표시할 위젯들을 정의
  late final List<Widget> _widgetOptions = <Widget>[
    const MainDdayView(), // Home 버튼에서 MainDdayView를 표시
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3), // X축 0, Y축 -2 (위로 2px 이동)
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
    const TimelinePage(),
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3), // X축 0, Y축 -2 (위로 2px 이동)
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
    Center(
      child: Transform.translate(
        offset: const Offset(0, -3), // X축 0, Y축 -2 (위로 2px 이동)
        child: Assets.icons.preparingIcon.svg(width: 94, height: 150),
      ),
    ),
  ];

  // 탭 선택 시 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onNotificationTab: () => {},
        onSettingTab: () => {},
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
              overlayColor:
                  WidgetStateProperty.all(Colors.transparent), // 터치 피드백 색상 제거
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
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: [
                NavigationDestination(
                  selectedIcon:
                      Assets.icons.homeIcon_on.svg(width: 24, height: 24),
                  icon: Assets.icons.homeIcon_off.svg(width: 24, height: 24),
                  label: l10n.home,
                ),
                NavigationDestination(
                  selectedIcon:
                      Assets.icons.coupleInfo_on.svg(width: 24, height: 24),
                  icon: Assets.icons.coupleInfo_off.svg(width: 24, height: 24),
                  label: l10n.coupleInfo,
                ),
                NavigationDestination(
                  selectedIcon:
                      Assets.icons.timelineIcon_on.svg(width: 24, height: 24),
                  icon:
                      Assets.icons.timelineIcon_off.svg(width: 24, height: 24),
                  label: l10n.timeline,
                ),
                NavigationDestination(
                  selectedIcon:
                      Assets.icons.challengeIcon_on.svg(width: 20, height: 20),
                  icon:
                      Assets.icons.challengeIcon_off.svg(width: 20, height: 20),
                  label: l10n.challenge,
                ),
                NavigationDestination(
                  selectedIcon:
                      Assets.icons.moreIcon_on.svg(width: 10, height: 10),
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
}
