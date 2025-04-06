import 'dart:async';

import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:couple_book/presentation/pages/timeline/models/anniversary_item.dart';
import 'package:couple_book/presentation/pages/timeline/models/timeline_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineState _state = TimelineState();

  TimelineState get state => _state;

  DateTime? _anniversaryDate;
  final DateTime _today = DateTime.now();
  DateTime _lastGeneratedDate = DateTime.now();
  bool _isLoadingMore = false;
  int _currentTabIndex = 0;

  final ScrollController scrollController0 = ScrollController();
  final ScrollController scrollController1 = ScrollController();

  TimelineViewModel() {
    scrollController0.addListener(_onScroll);
    scrollController1.addListener(_onScroll);
    _initialize();
  }

  Future<void> _initialize() async {
    _anniversaryDate = await LocalUserLocalDataSource.instance.getAnniversaryToDatetime();
    final user = await UserLocalDataSource.instance.getUser();
    final partner = await PartnerLocalDataSource.instance.getPartner();

    _state = _state.copyWith(
      myName: user?.name,
      myBirthday: user?.birthday,
      partnerName: partner?.name,
      partnerBirthday: partner?.birthday,
    );

    if (_anniversaryDate == null) return;

    _lastGeneratedDate = _anniversaryDate!.add(const Duration(days: 2000));
    _addItem('사귄 날', _anniversaryDate!);
    await _appendMoreAnniversaries(scrollToToday: true);
  }

  void updateTabIndex(int index) {
    _currentTabIndex = index;

    Future.delayed(const Duration(milliseconds: 150), () {
      if (index == 0) {
        _scrollToIndex(
          condition: (item) => item.isToday,
          controller: scrollController0,
        );
      } else if (index == 1) {
        _scrollToIndex(
          condition: (item) => item.label == '사귄 날',
          controller: scrollController1,
        );
      }
    });
  }

  /// 특정 조건의 항목으로 스크롤
  void _scrollToIndex({
    required bool Function(AnniversaryItem) condition,
    required ScrollController controller,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _state.anniversaries.indexWhere(condition);
      if (index == -1 || !controller.hasClients || !controller.position.hasContentDimensions) return;

      final offset = _calculateOffset(index, controller);
      controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  double _calculateOffset(int index, ScrollController controller) {
    final screenHeight = controller.position.viewportDimension;
    return (48.0 + index * 48.0) - screenHeight * 0.3;
  }

  Future<void> _appendMoreAnniversaries({bool scrollToToday = false}) async {
    final nextTarget = _lastGeneratedDate.add(const Duration(days: 2000));

    for (int i = 1;; i++) {
      final day = _anniversaryDate!.add(Duration(days: i));
      if (day.isAfter(nextTarget)) break;

      final diff = day.difference(_anniversaryDate!).inDays;
      final isToday = _isSameDate(day, _today);
      final hasTodayAlready = _state.anniversaries.any((e) => e.isToday);

      if (diff % 100 == 0) _addItem('$diff일', day);
      if (_isAnniversary(day)) _addItem('${day.year - _anniversaryDate!.year}주년', day);

      _addBirthdayIfMatch(day, _state.myBirthday, '${_state.myName ?? '내'} 생일 🎂', markToday: isToday && !hasTodayAlready);
      _addBirthdayIfMatch(day, _state.partnerBirthday, '${_state.partnerName ?? '상대'} 생일 🎂', markToday: isToday && !hasTodayAlready);
    }

    _lastGeneratedDate = nextTarget;
    _state = _state.copyWith(
      anniversaries: _state.anniversaries..sort(_sortByDate),
    );
    notifyListeners();

    if (scrollToToday && _currentTabIndex == 0) {
      _scrollToIndex(
        condition: (item) => item.isToday,
        controller: scrollController0,
      );
    }
  }

  void _addItem(String label, DateTime date) {
    final formatted = DateFormat('yyyy/MM/dd(E)', 'ko_KR').format(date);
    final dDay = _calculateDDay(date);
    final key = '$label|$formatted';

    if (_state.generatedKeys.contains(key)) return;

    _state.anniversaries.add(
      AnniversaryItem(
        label: label,
        date: formatted,
        dDay: dDay,
        isToday: _isSameDate(date, _today),
      ),
    );
    _state.generatedKeys.add(key);
  }

  void _addBirthdayIfMatch(DateTime day, String? birthday, String label, {bool markToday = false}) {
    if (birthday == null) return;

    final parts = birthday.split('-');
    if (parts.length != 3) return;

    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (m == null || d == null) return;

    if (day.month == m && day.day == d) _addItem(label, day);
  }

  void _onScroll() {
    final controller = _currentTabIndex == 0 ? scrollController0 : scrollController1;
    if (!_isLoadingMore && controller.position.pixels >= controller.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      Future.delayed(const Duration(milliseconds: 300), () async {
        await _appendMoreAnniversaries();
        _isLoadingMore = false;
      });
    }
  }

  bool _isAnniversary(DateTime day) {
    return day.year - _anniversaryDate!.year >= 1 && day.month == _anniversaryDate!.month && day.day == _anniversaryDate!.day;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _calculateDDay(DateTime date) {
    final diff = date.difference(_today).inDays;
    return diff == 0 ? '오늘' : (diff > 0 ? 'D-$diff' : 'D+${-diff}');
  }

  int _sortByDate(AnniversaryItem a, AnniversaryItem b) {
    final format = DateFormat('yyyy/MM/dd(E)', 'ko_KR');
    return format.parse(a.date).compareTo(format.parse(b.date));
  }

  @override
  void dispose() {
    scrollController0.dispose();
    scrollController1.dispose();
    super.dispose();
  }
}
