import 'package:flutter/material.dart';

import '../../../domain/entities/calendar/calendar_state.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarState _state;

  CalendarViewModel({DateTime? selectedDate})
      : _state = CalendarState(
          selectedDate: selectedDate ?? DateTime.now(),
          focusedDate: selectedDate ?? DateTime.now(),
        );

  CalendarState get state => _state;

  void updateFocusedDate(DateTime date) {
    _state = _state.copyWith(focusedDate: date);
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    _state = _state.copyWith(
      selectedDate: date,
      focusedDate: date,
    );
    notifyListeners();
  }

  String get formattedCurrentMonth => '${_state.focusedDate?.year}년 ${_state.focusedDate?.month}월';
}
