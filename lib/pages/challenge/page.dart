import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
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
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
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
                Container(
                  width: double.infinity,
                  height: 36,
                  child: Center(
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                          color: _tabController.index == 0
                              ? Colors.orange
                              : Colors.grey),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 36,
                  child: Center(
                    child: Text(
                      '첫날보기',
                      style: TextStyle(
                          color: _tabController.index == 1
                              ? Colors.orange
                              : Colors.grey),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// 리스트 항목을 체크박스와 함께 그리기
  Widget buildAnniversaryList() {
    final anniversaries = [
      {'label': '200일', 'date': '2024/08/05(금)', 'dDay': 'D+209'},
      {'label': '258일', 'date': '2024/08/05(금)', 'dDay': '오늘'},
      {'label': '300일', 'date': '2024/08/05(금)', 'dDay': 'D+58'},
      {'label': '1주년', 'date': '2024/08/05(금)', 'dDay': 'D+28'},
      {'label': '결혼기념일', 'date': '2024/08/05(금)', 'dDay': 'D+120'},
      {'label': '400일', 'date': '2024/08/05(금)', 'dDay': 'D-42'},
    ];

    return ListView.builder(
      itemCount: anniversaries.length + 1, // 상단 타이틀 추가를 위해 +1
      itemBuilder: (context, index) {
        if (index == 0) {
          // 상단 타이틀 추가
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(width: 50), // 체크박스 공간을 위한 여백
                Expanded(
                  child: Text(
                    '기념일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '디데이',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          final anniversary = anniversaries[index - 1]; // 실제 데이터는 index-1로 접근
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(value: false, onChanged: (bool? value) {}),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anniversary['label']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                    Text(
                      anniversary['dDay']!,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1), // 구분선 추가
            ],
          );
        }
      },
    );
  }
}
