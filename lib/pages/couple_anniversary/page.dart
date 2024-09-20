import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/router.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class CoupleAnniversaryPage extends StatefulWidget {
  const CoupleAnniversaryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CoupleAnniversaryPageState createState() => _CoupleAnniversaryPageState();
}

class _CoupleAnniversaryPageState extends State<CoupleAnniversaryPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveDateAndNavigate() async {
    if (_selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'couple_anniversary', _selectedDate!.toIso8601String());
      logger.i('선택된 날짜 저장: $_selectedDate');

      if (mounted) {
        context.goNamed(ViewRoute.home.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundColor,
      appBar: AppBar(
        title: const Text('커플 기념일 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const AppText(
              '처음 만난 날을 설정해주세요',
              style: TypoStyle.notoSansSemiBold22,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(_selectedDate == null
                  ? '날짜 선택'
                  : '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일'),
              onPressed: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedDate == null ? null : _saveDateAndNavigate,
              child: const Text('설정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
