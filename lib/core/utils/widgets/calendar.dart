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
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime? _focusedDate;
  DateTime? _selectedDate;

  /// TODO: 최소, 최대 날짜 재설정 필요 ( 설정이 필요 없는 방법은 없나 서칭 필요 )
  final DateTime _firstDay = DateTime.utc(1900, 1, 1);
  final DateTime _lastDay = DateTime.utc(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _focusedDate = _selectedDate;
  }

  /// 📌 **월/년도 선택 다이얼로그**
  Future<void> _showYearMonthPicker() async {
    DateTime tempDate = _focusedDate ?? DateTime.now();

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: tempDate,
                onDateTimeChanged: (DateTime newDate) {
                  tempDate = DateTime(newDate.year, newDate.month, 1);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!mounted) return;
                setState(() {
                  _focusedDate = tempDate;
                });
                Navigator.pop(context);
              },
              child: const Text("확인"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.6,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 📌 **월/년도 표시 및 선택 버튼**
                  GestureDetector(
                    onTap: _showYearMonthPicker, // 🔥 다이얼로그 실행
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${_focusedDate?.year ?? DateTime.now().year}년 ${_focusedDate?.month ?? DateTime.now().month}월',
                        style: const TextStyle(fontSize: 20.0, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// 📌 **캘린더 UI (월 변경 막고, 선택된 월만 표시)**
                  SizedBox(
                    height: 350,
                    child: TableCalendar(
                      locale: 'ko_KR',
                      firstDay: _firstDay,
                      lastDay: _lastDay,
                      focusedDay: _focusedDate!,
                      headerVisible: false, // 🔥 월 변경 버튼 제거
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDate = focusedDay;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          /// 📌 **확인 버튼 (하단 고정)**
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
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
            ),
          ),
        ],
      ),
    );
  }
}
