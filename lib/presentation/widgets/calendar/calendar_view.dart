import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/presentation/widgets/calendar/year_month_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_view_model.dart';

class CalendarView extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDaySelected;

  const CalendarView({
    super.key,
    required this.onDaySelected,
    this.selectedDate,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showYearMonthPicker(BuildContext context, CalendarViewModel viewModel) {
    final currentSelectedDate = viewModel.state.selectedDate ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => YearMonthPicker(
        initialDate: currentSelectedDate,
        onDateSelected: (DateTime date) {
          viewModel.updateFocusedDate(date);
          viewModel.updateSelectedDate(date);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => CalendarViewModel(selectedDate: selectedDate),
      child: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          final currentDate = viewModel.state.focusedDate ?? DateTime.now();
          final selectedDate = viewModel.state.selectedDate;

          return SizedBox(
            height: screenHeight * 0.6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _showYearMonthPicker(context, viewModel),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              viewModel.formattedCurrentMonth,
                              style: const TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 350,
                          child: TableCalendar(
                            locale: 'ko_KR',
                            firstDay: viewModel.state.firstDay,
                            lastDay: viewModel.state.lastDay,
                            focusedDay: selectedDate ?? currentDate,
                            headerVisible: false,
                            selectedDayPredicate: (day) => selectedDate != null && _isSameDay(day, selectedDate),
                            onDaySelected: (selectedDay, focusedDay) {
                              viewModel.updateSelectedDate(selectedDay);
                              viewModel.updateFocusedDate(selectedDay);
                            },
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
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
                        if (selectedDate != null) {
                          onDaySelected(selectedDate);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
