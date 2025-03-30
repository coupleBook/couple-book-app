import 'package:flutter/material.dart';
import '../models/timeline_state.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineState _state;
  late TabController _tabController;

  TimelineViewModel(TickerProvider vsync) : _state = TimelineState() {
    _tabController = TabController(length: 2, vsync: vsync);
    _tabController.addListener(_onTabChanged);
    _loadAnniversaries();
  }

  TimelineState get state => _state;
  TabController get tabController => _tabController;

  void _onTabChanged() {
    _state = _state.copyWith(selectedTabIndex: _tabController.index);
    notifyListeners();
  }

  Future<void> _loadAnniversaries() async {
    // TODO: 실제 데이터 로드 로직 구현
    final anniversaries = [
      AnniversaryItem(label: '200일', date: '2024/08/05(금)', dDay: 'D+209'),
      AnniversaryItem(label: '258일', date: '2024/08/05(금)', dDay: '오늘'),
      AnniversaryItem(label: '300일', date: '2024/08/05(금)', dDay: 'D+58'),
      AnniversaryItem(label: '1주년', date: '2024/08/05(금)', dDay: 'D+28'),
      AnniversaryItem(label: '결혼기념일', date: '2024/08/05(금)', dDay: 'D+120'),
      AnniversaryItem(label: '400일', date: '2024/08/05(금)', dDay: 'D-42'),
      AnniversaryItem(label: '500일', date: '2024/08/05(금)', dDay: 'D-42'),
      AnniversaryItem(label: '600일', date: '2024/08/05(금)', dDay: 'D-42'),
      AnniversaryItem(label: '700일', date: '2024/08/05(금)', dDay: 'D-42'),
      AnniversaryItem(label: '800일', date: '2024/08/05(금)', dDay: 'D-42'),
    ];

    _state = _state.copyWith(anniversaries: anniversaries);
    notifyListeners();
  }

  void toggleCheckbox(String id) {
    final newCheckedItems = Map<String, bool>.from(_state.checkedItems);
    newCheckedItems[id] = !(newCheckedItems[id] ?? false);
    _state = _state.copyWith(checkedItems: newCheckedItems);
    notifyListeners();
  }

  bool isChecked(String id) {
    return _state.checkedItems[id] ?? false;
  }

  void onAddAnniversary() {
    // TODO: 기념일 추가 로직 구현
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 