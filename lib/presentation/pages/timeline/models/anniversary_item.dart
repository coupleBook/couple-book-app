class AnniversaryItem {
  final String label;
  final String date;
  final String dDay;

  AnniversaryItem({
    required this.label,
    required this.date,
    required this.dDay,
  });

  String get id => '$label|$date';
}
