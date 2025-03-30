import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearMonthPicker extends StatelessWidget {
  final DateTime initialDate;
  final void Function(DateTime) onDateSelected;

  const YearMonthPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    DateTime tempDate = initialDate;

    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              onDateTimeChanged: (DateTime newDate) {
                tempDate = newDate;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDateSelected(tempDate);
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }
}
