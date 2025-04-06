import 'dart:async';

import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/anniversary_item.dart';
import '../models/timeline_state.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineState _state = TimelineState();

  TimelineState get state => _state;

  DateTime? _anniversaryDate;
  DateTime _lastGeneratedDate = DateTime.now();
  bool _isLoadingMore = false;

  int _currentTabIndex = 0;

  final ScrollController scrollController = ScrollController();

  TimelineViewModel() {
    scrollController.addListener(_onScroll);
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

    final now = DateTime.now();
    _lastGeneratedDate = _anniversaryDate!.add(const Duration(days: 2000));

    _addItem("사귄 날", _anniversaryDate!);
    _addItem("오늘", now); // 잠시 추가. 이후 중복되면 제거

    await _appendMoreAnniversaries();

    // 중복 날짜가 있으면 '오늘' 제거
    _removeTodayIfDuplicate();

    _scrollToToday();
  }

  void updateTabIndex(int index) {
    _currentTabIndex = index;

    if (index == 0) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToToday);
    } else if (index == 1) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToFirstDay);
    }
  }

  void _scrollToToday() {
    final todayStr = DateFormat('yyyy/MM/dd(E)', 'ko_KR').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _state.anniversaries.indexWhere((e) => e.date == todayStr);
      if (index != -1 && scrollController.hasClients && scrollController.position.hasContentDimensions) {
        final screenHeight = MediaQuery.of(scrollController.position.context.storageContext).size.height;
        final offset = 48.0 + (index * 48.0) - (screenHeight * 0.3);
        scrollController.jumpTo(offset.clamp(0.0, scrollController.position.maxScrollExtent));
      }
    });
  }

  void _scrollToFirstDay() {
    final index = _state.anniversaries.indexWhere((e) => e.label == '사귄 날');
    if (index != -1 && scrollController.hasClients && scrollController.position.hasContentDimensions) {
      final screenHeight = MediaQuery.of(scrollController.position.context.storageContext).size.height;
      final offset = 48.0 + (index * 48.0) - (screenHeight * 0.3);
      scrollController.jumpTo(offset.clamp(0.0, scrollController.position.maxScrollExtent));
    }
  }

  void _removeTodayIfDuplicate() {
    final today = DateFormat('yyyy/MM/dd(E)', 'ko_KR').format(DateTime.now());

    final hasOtherEvent = _state.anniversaries.any((item) => item.date == today && item.label != '오늘');
    if (hasOtherEvent) {
      final filtered = _state.anniversaries.where((item) => item.label != '오늘').toList();
      _state = _state.copyWith(anniversaries: filtered);
      notifyListeners();
    }
  }

  Future<void> _appendMoreAnniversaries() async {
    final nextTarget = _lastGeneratedDate.add(const Duration(days: 2000));

    for (int i = 1;; i++) {
      final day = _anniversaryDate!.add(Duration(days: i));
      if (day.isAfter(nextTarget)) break;

      final diff = day.difference(_anniversaryDate!).inDays;

      if (diff % 100 == 0) {
        _addItem("$diff일", day);
      }

      if (day.year - _anniversaryDate!.year >= 1 && day.month == _anniversaryDate!.month && day.day == _anniversaryDate!.day) {
        final years = day.year - _anniversaryDate!.year;
        _addItem("${years}주년", day);
      }

      _addBirthdayIfMatch(day, _state.myBirthday, "${_state.myName ?? '내'} 생일 🎂");
      _addBirthdayIfMatch(day, _state.partnerBirthday, "${_state.partnerName ?? '상대'} 생일 🎂");
    }

    _lastGeneratedDate = nextTarget;

    final sortedList = List<AnniversaryItem>.from(_state.anniversaries);
    sortedList.sort((a, b) => DateFormat('yyyy/MM/dd(E)', 'ko_KR').parse(a.date).compareTo(DateFormat('yyyy/MM/dd(E)', 'ko_KR').parse(b.date)));

    _state = _state.copyWith(
      anniversaries: sortedList,
    );
    notifyListeners();
  }

  void _addItem(String label, DateTime date) {
    final formatted = DateFormat('yyyy/MM/dd(E)', 'ko_KR').format(date);
    final diff = date.difference(DateTime.now()).inDays;
    final dDay = diff == 0 ? '오늘' : (diff > 0 ? 'D-$diff' : 'D+${-diff}');
    final key = '$label|$formatted';

    if (_state.generatedKeys.contains(key)) return;

    _state.anniversaries.add(AnniversaryItem(label: label, date: formatted, dDay: dDay));
    _state.generatedKeys.add(key);
  }

  void _addBirthdayIfMatch(DateTime day, String? birthday, String label) {
    if (birthday == null) return;
    final parts = birthday.split('-');
    if (parts.length != 3) return;

    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (m == null || d == null) return;

    if (m == day.month && d == day.day) {
      _addItem(label, day);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        Future.delayed(const Duration(milliseconds: 300), () async {
          await _appendMoreAnniversaries();
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
