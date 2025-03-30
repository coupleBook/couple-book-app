import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/colors.gen.dart';
import '../../core/theme/text_style.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6D8),
      body: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              tabBarTheme: TabBarTheme(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.transparent;
                    }
                    return null;
                  },
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: _tabController.index == 0
                    ? const BorderRadius.only(topRight: Radius.circular(30.0))
                    : const BorderRadius.only(topLeft: Radius.circular(30.0)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              onTap: (index) {
                setState(() {
                  // 탭을 클릭할 때 다시 그리기
                });
              },
              tabs: [
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: Center(
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                          color: _tabController.index == 0
                              ? ColorName.pointBtnBg
                              : ColorName.defaultGray),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: Center(
                    child: Text(
                      '첫날보기',
                      style: TextStyle(
                          color: _tabController.index == 1
                              ? ColorName.pointBtnBg
                              : ColorName.defaultGray),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildAnniversaryList(),
                buildAnniversaryList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 리스트 항목을 체크박스와 함께 그리기
  /// TODO: page.dart 파일이 아닌 위젯 파일로 따로 분리 필요
  Widget buildAnniversaryList() {
    final anniversaries = [
      {'label': '200일', 'date': '2024/08/05(금)', 'dDay': 'D+209'},
      {'label': '258일', 'date': '2024/08/05(금)', 'dDay': '오늘'},
      {'label': '300일', 'date': '2024/08/05(금)', 'dDay': 'D+58'},
      {'label': '1주년', 'date': '2024/08/05(금)', 'dDay': 'D+28'},
      {'label': '결혼기념일', 'date': '2024/08/05(금)', 'dDay': 'D+120'},
      {'label': '400일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
      {'label': '500일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
      {'label': '600일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
      {'label': '700일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
      {'label': '800일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
    ];

    return ListView.builder(
      itemCount: anniversaries.length + 1, // 상단 타이틀 추가를 위해 +1
      itemBuilder: (context, index) {
        if (index == 0) {
          // 상단 타이틀 추가
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 가로선 (SizedBox 사용하여 구현)
                SizedBox(
                  height: 1.8,
                  child: Container(
                    color: ColorName.defaultGray,
                  ),
                ),

                SizedBox(
                  height: 46.0, // 고정된 높이
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 7, /// 70%
                        child: Align(
                          alignment: Alignment.center,
                          child: AppText(
                            '기념일',
                            style: TypoStyle.notoSansR19_1_4.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                            color: ColorName.defaultGray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 1.0,
                        color: ColorName.defaultGray,
                      ),

                      Expanded(
                        flex: 3, /// 30%
                        child: Align(
                          alignment: Alignment.center,
                          child: AppText(
                            '디데이',
                            style: TypoStyle.notoSansR19_1_4.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                            color: ColorName.defaultGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: ColorName.defaultGray,
                  ),
                ),
              ],
            ),
          );
        } else {
          final anniversary = anniversaries[index - 1]; // 실제 데이터는 index-1로 접근
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 46.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 체크박스
                          Checkbox(value: false, onChanged: (bool? value) {}),
                          Expanded(
                            flex: 7, /// 70%
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  anniversary['label']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  anniversary['date']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1.0, /// 세로선 두께
                            color: ColorName.defaultGray,
                            margin: const EdgeInsets.symmetric(horizontal: 12.0),
                          ),

                          Expanded(
                            flex: 3, /// 30%
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                anniversary['dDay']!,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 1.0,
                      child: Container(
                        color: ColorName.defaultGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
