class CalendarState {
  final DateTime? focusedDate;
  final DateTime? selectedDate;
  final DateTime firstDay;
  final DateTime lastDay;

  CalendarState({
    this.focusedDate,
    this.selectedDate,
    DateTime? firstDay,
    DateTime? lastDay,
  })  : firstDay = firstDay ?? DateTime.utc(1900, 1, 1),
        lastDay = lastDay ?? DateTime.utc(2100, 12, 31);

  CalendarState copyWith({
    DateTime? focusedDate,
    DateTime? selectedDate,
    DateTime? firstDay,
    DateTime? lastDay,
  }) {
    return CalendarState(
      focusedDate: focusedDate ?? this.focusedDate,
      selectedDate: selectedDate ?? this.selectedDate,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
    );
  }
}