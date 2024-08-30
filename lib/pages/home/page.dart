// HomePage.dart

import 'package:COUPLE_BOOK/gen/colors.gen.dart';
import 'package:COUPLE_BOOK/pages/home/widget/home_app_bar.dart';
import 'package:COUPLE_BOOK/pages/home/widget/main_dday.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가

import '../../gen/assets.gen.dart';
import '../../l10n/l10n.dart';
import '../../style/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 현재 날짜와 D-day 계산
  final String today = DateFormat('yy/MM/dd/E', 'ko_KR').format(DateTime.now());
  final int dday = DateTime.now().difference(DateTime(2023, 11, 25)).inDays;


  // 각 탭에서 표시할 위젯들을 정의
  late final List<Widget> _widgetOptions = <Widget>[
    MainDdayView(today: today, dday: dday), // Home 버튼에서 MainDdayView를 표시
    Center(child: AppText('커플정보')),
    Center(child: AppText('타임라인')),
    Center(child: AppText('챌린지')),
    Center(child: AppText('더보기')),
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
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontFamily: 'Iseoyunchae',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
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
                  selectedIcon: Assets.icons.homeIcon_on.svg(width: 24, height: 24),
                  icon: Assets.icons.homeIcon_off.svg(width: 24, height: 24),
                  label: l10n.home,
                ),
                NavigationDestination(
                  selectedIcon: Assets.icons.coupleInfo_on.svg(width: 24, height: 24),
                  icon: Assets.icons.coupleInfo_off.svg(width: 24, height: 24),
                  label: l10n.couple_info,
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
}
