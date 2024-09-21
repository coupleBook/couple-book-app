import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/router.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';

final logger = Logger();

class CoupleAnniversaryPage extends StatefulWidget {
  const CoupleAnniversaryPage({super.key});

  @override
  _CoupleAnniversaryPageState createState() => _CoupleAnniversaryPageState();
}

class _CoupleAnniversaryPageState extends State<CoupleAnniversaryPage> {
  DateTime? _selectedDate;

  /// ************************************************
  /// flutter 기본 날짜 달력 VIEW and 지정 날짜 저장
  /// ************************************************
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

  /// ************************************************
  /// 선택된 날짜 저장 후 홈으로 이동
  /// ************************************************
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
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6D8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '처음 만난 날 설정하기',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorName.pointBtnBg,
                foregroundColor: Colors.black87,
                minimumSize: Size(screenWidth * 0.84, 68),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: AppText(_selectedDate == null
                      ? l10n.selectDate
                      : '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
                  style: TypoStyle.notoSansSemiBold13_1_4.copyWith(fontSize: 15, letterSpacing: -0.2),
                  color: ColorName.defaultGray),
              onPressed: () => _selectDate(context),
            ),
            const SizedBox(height: 13),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      // 버튼이 비활성화 상태일 때의 배경색
                      return ColorName.defaultGray;
                    }
                    // 버튼이 활성화 상태일 때의 배경색
                    return ColorName.defaultBlack;
                  },
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.84, 68)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: _selectedDate == null ? null : _saveDateAndNavigate,
              child: AppText(l10n.confirmSetting,
                  style: TypoStyle.notoSansSemiBold13_1_4.copyWith(fontSize: 15, letterSpacing: -0.2),
                  color:  _selectedDate == null ? ColorName.pointBtnBg : ColorName.white),
            ),

          ],
        ),
      ),
    );
  }
}
