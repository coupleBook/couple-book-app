class TimelineState {
  final int selectedTabIndex;
  final List<AnniversaryItem> anniversaries;
  final Map<String, bool> checkedItems;

  TimelineState({
    this.selectedTabIndex = 0,
    this.anniversaries = const [],
    this.checkedItems = const {},
  });

  TimelineState copyWith({
    int? selectedTabIndex,
    List<AnniversaryItem>? anniversaries,
    Map<String, bool>? checkedItems,
  }) {
    return TimelineState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      anniversaries: anniversaries ?? this.anniversaries,
      checkedItems: checkedItems ?? this.checkedItems,
    );
  }
}

class AnniversaryItem {
  final String label;
  final String date;
  final String dDay;

  AnniversaryItem({
    required this.label,
    required this.date,
    required this.dDay,
  });

  String get id => '$label-$date'; // 체크박스 상태 관리를 위한 고유 ID
} 