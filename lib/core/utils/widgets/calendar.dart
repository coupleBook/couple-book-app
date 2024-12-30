import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../gen/colors.gen.dart';

class Calendar extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDaySelected;

  const Calendar({
    super.key,
    required this.onDaySelected,
    this.selectedDate,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _focusedDate;
  DateTime? _selectedDate;
  bool _isYearMonthPickerVisible = false;

  /// TODO: 최소, 최대 날짜 재설정 필요 ( 설정이 필요 없는 방법은 없나 서칭 필요 )
  final DateTime _firstDay = DateTime.utc(0021, 10, 16);
  final DateTime _lastDay = DateTime.utc(9030, 3, 14);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _focusedDate = _selectedDate;

    // focusedDate가 firstDay보다 이전인 경우 firstDay로 초기화
    if (_focusedDate!.isBefore(_firstDay)) {
      _focusedDate = _firstDay;
    }
  }

  /// ************************************************
  /// 년, 월, 일 선택 UI를 캘린더 TableCalendar 대신 보여줌
  /// TODO: 확인 버튼 임시 적용 기능 개발 후 삭제 필요
  /// ************************************************
  Widget _buildYearMonthPicker() {
    int selectedYear = _focusedDate!.year;
    int selectedMonth = _focusedDate!.month;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(selectedYear, selectedMonth),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _focusedDate =
                    DateTime(newDate.year, newDate.month, newDate.day);
                _selectedDate =
                    DateTime(newDate.year, newDate.month, newDate.day);
                // focusedDate가 firstDay보다 이전인 경우 firstDay로 설정
                if (_focusedDate!.isBefore(_firstDay)) {
                  _focusedDate = _firstDay;
                }
              });
            },
            use24hFormat: true,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isYearMonthPickerVisible = false;
            });
          },
          child: const Text("확인"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isYearMonthPickerVisible = true;
            });
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${_focusedDate!.year}년 ${_focusedDate!.month}월',
              style: const TextStyle(fontSize: 20.0, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _isYearMonthPickerVisible
            ? _buildYearMonthPicker()
            : Expanded(
                child: TableCalendar(
                  locale: 'ko_KR',
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDate!,
                  headerVisible: _isYearMonthPickerVisible,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;

                      if (_focusedDate!.isBefore(_firstDay)) {
                        _focusedDate = _firstDay;
                      }
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                    ),
                    leftChevronIcon: Icon(
                      Icons.arrow_left,
                      size: 40.0,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_right,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorName.pointBtnBg,
            foregroundColor: Colors.black87,
            minimumSize: Size(screenWidth * 0.84, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () {
            widget.onDaySelected(_selectedDate!);
            Navigator.pop(context);
          },
          child: const Text('확인'),
        ),
        const SizedBox(height: 34),
      ],
    );
  }
}
