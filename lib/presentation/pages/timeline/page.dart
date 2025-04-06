import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/core/theme/text_style.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  final List<Map<String, String>> _anniversaries = [];
  final Set<String> _generatedLabels = {};
  DateTime? _anniversaryDate;
  DateTime _lastGeneratedDate = DateTime.now();
  bool _isLoadingMore = false;
  bool _initialScrollDone = false;
  String? _myBirthday;
  String? _myName;
  String? _partnerBirthday;
  String? _partnerName;

  static const int loadIntervalDays = 2000;
  static const double itemHeight = 48.0;
  static const double headerHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadInitialAnniversaries();
  }

  Future<void> _loadInitialAnniversaries() async {
    _anniversaryDate = await LocalUserLocalDataSource.instance.getAnniversaryToDatetime();
    final user = await UserLocalDataSource.instance.getUser();
    final partner = await PartnerLocalDataSource.instance.getPartner();
    _myBirthday = user?.birthday;
    _myName = user?.name;
    _partnerBirthday = partner?.birthday;
    _partnerName = partner?.name;

    if (_anniversaryDate == null) return;

    final now = DateTime.now();
    _lastGeneratedDate = _anniversaryDate!.add(const Duration(days: loadIntervalDays));

    _addItem("사귄 날", _anniversaryDate!, _anniversaryDate!);
    _addItem("오늘", now, _anniversaryDate!);

    await _appendFutureAnniversaries(scrollToToday: true);
  }

  Future<void> _appendFutureAnniversaries({bool scrollToToday = false}) async {
    final nextTargetDate = _lastGeneratedDate.add(const Duration(days: loadIntervalDays));

    for (int i = 1;; i++) {
      final day = _anniversaryDate!.add(Duration(days: i));
      if (day.isAfter(nextTargetDate)) break;

      final difference = day.difference(_anniversaryDate!).inDays;
      if (difference % 100 == 0) {
        _addItem("$difference일", day, _anniversaryDate!);
      }
      if (day.year - _anniversaryDate!.year >= 1 &&
          day.month == _anniversaryDate!.month &&
          day.day == _anniversaryDate!.day) {
        final years = day.year - _anniversaryDate!.year;
        _addItem("$years주년", day, _anniversaryDate!);
      }

      // 사용자/파트너 생일 추가
      if (_myBirthday != null) {
        final parts = _myBirthday!.split('-');
        final birthMonth = int.tryParse(parts[1]);
        final birthDay = int.tryParse(parts[2]);
        if (birthMonth == day.month && birthDay == day.day) {
          _addItem("$_myName 생일 🎂", day, _anniversaryDate!);
        }
      }

      if (_partnerBirthday != null) {
        final parts = _partnerBirthday!.split('-');
        final birthMonth = int.tryParse(parts[1]);
        final birthDay = int.tryParse(parts[2]);
        if (birthMonth == day.month && birthDay == day.day) {
          _addItem("$_partnerName 생일 🎂", day, _anniversaryDate!);
        }
      }
    }

    _lastGeneratedDate = nextTargetDate;
    _anniversaries.sort((a, b) => DateFormat('yyyy/MM/dd(E)', 'ko_KR')
        .parse(a['date']!)
        .compareTo(DateFormat('yyyy/MM/dd(E)', 'ko_KR').parse(b['date']!)));

    setState(() {
      _isLoadingMore = false;
    });

    if (scrollToToday || !_initialScrollDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final todayIndex = _anniversaries.indexWhere((item) => item['label'] == '오늘');
        if (todayIndex != -1) {
          final screenHeight = MediaQuery.of(context).size.height;
          final offset = headerHeight + (todayIndex * itemHeight) - (screenHeight * 0.3);
          _scrollController.jumpTo(offset.clamp(0, _scrollController.position.maxScrollExtent));
          _initialScrollDone = true;
        }
      });
    }
  }

  void _addItem(String label, DateTime date, DateTime baseDate) {
    final dateStr = DateFormat('yyyy/MM/dd(E)', 'ko_KR').format(date);
    final difference = date.difference(DateTime.now()).inDays;
    final dDay = difference == 0 ? '오늘' : (difference > 0 ? 'D-$difference' : 'D+${-difference}');
    final uniqueKey = '$label|$dateStr';
    if (_generatedLabels.contains(uniqueKey)) return;

    _anniversaries.add({'label': label, 'date': dateStr, 'dDay': dDay});
    _generatedLabels.add(uniqueKey);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          _appendFutureAnniversaries();
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6D8),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnniversaryList(),
                _buildAnniversaryList(),
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

  Widget _buildTabBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (states) => states.contains(WidgetState.pressed) ? Colors.transparent : null,
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
        onTap: (_) => setState(() {}),
        tabs: [
          _buildTabText('전체보기', 0),
          _buildTabText('첫날보기', 1),
        ],
      ),
    );
  }

  Widget _buildTabText(String title, int index) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: _tabController.index == index ? ColorName.pointBtnBg : ColorName.defaultGray,
          ),
        ),
      ),
    );
  }

  Widget _buildAnniversaryList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _anniversaries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildListHeader();
        final anniversary = _anniversaries[index - 1];
        return _buildAnniversaryItem(anniversary);
      },
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          SizedBox(height: 1.8, child: Container(color: ColorName.defaultGray)),
          SizedBox(
            height: 46.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  flex: 7,
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
                Container(width: 1.0, color: ColorName.defaultGray),
                Expanded(
                  flex: 3,
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
          SizedBox(height: 1.0, child: Container(color: ColorName.defaultGray)),
        ],
      ),
    );
  }

  Widget _buildAnniversaryItem(Map<String, String> item) {
    final isToday = item['label'] == '오늘';
    final isFirstDayTab = _tabController.index == 1 && item['label'] == '사귄 날';
    final isHighlighted = isToday || isFirstDayTab;

    final labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: isHighlighted ? Colors.orange : Colors.black,
    );
    final dateStyle = TextStyle(
      color: isHighlighted ? Colors.orange : Colors.grey,
      fontSize: 14,
    );
    final dDayStyle = TextStyle(
      color: isHighlighted ? Colors.orange : Colors.orange,
      fontSize: 16,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(
                height: 46.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Checkbox(value: false, onChanged: (_) {}),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['label']!, style: labelStyle),
                          Text(item['date']!, style: dateStyle),
                        ],
                      ),
                    ),
                    Container(width: 1.0, color: ColorName.defaultGray, margin: const EdgeInsets.symmetric(horizontal: 12.0)),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          item['dDay']!,
                          style: dDayStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.0, child: Container(color: ColorName.defaultGray)),
            ],
          ),
        ),
      ],
    );
  }
}
