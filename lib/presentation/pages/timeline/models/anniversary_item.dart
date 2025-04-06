class AnniversaryItem {
  final String label;
  final String date;
  final String dDay;
  final bool isToday; // 추가

  AnniversaryItem({
    required this.label,
    required this.date,
    required this.dDay,
    this.isToday = false,
  });

  String get id => '$label|$date';
}
