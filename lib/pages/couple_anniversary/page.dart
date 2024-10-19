import 'package:couple_book/utils/security/couple_security.dart';
import 'package:flutter/material.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/router.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/l10n.dart';
import '../../utils/widgets/calendar.dart';  // Calendar 위젯 임포트

final logger = Logger();

class CoupleAnniversaryPage extends StatefulWidget {
  const CoupleAnniversaryPage({super.key});

  @override
  _CoupleAnniversaryPageState createState() => _CoupleAnniversaryPageState();
}

class _CoupleAnniversaryPageState extends State<CoupleAnniversaryPage> {
  DateTime? _selectedDate;

  /// ************************************************
  /// 화면의 절반 높이만 차지하는 달력 모달 뷰
  /// ************************************************
  Future<void> _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,  // 배경을 투명하게 설정
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,  // 화면의 절반만 차지하게 설정
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),  // 모서리를 둥글게
              ),
            ),
            child: Calendar(
              selectedDate: _selectedDate,  // 선택된 날짜 전달
              onDaySelected: (selectedDay) {
                setState(() {
                  _selectedDate = selectedDay;  // 선택된 날짜 저장
                });
              },
            ),
          ),
        );
      },
    );
  }

  /// ************************************************
  /// 선택된 날짜 저장 후 홈으로 이동
  /// ************************************************
  Future<void> _saveDateAndNavigate() async {
    if (_selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('couple_anniversary', _selectedDate!.toIso8601String());
      await setAnniversary(_selectedDate);

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
            SizedBox(
              width: screenWidth * 0.9,
              height: 100,  // 박스의 높이를 지정하여 충분한 공간을 확보
              child: Stack(
                alignment: Alignment.bottomCenter,  // 텍스트와 이미지를 중앙에 맞춤
                children: [
                  Positioned(
                    bottom: 0,
                    right: screenWidth * 0.11,
                    child: Assets.icons.pencilUnderlineBg.svg(
                      width: screenWidth * 0.64,  // 텍스트 너비에 맞게 이미지 크기 설정
                      fit: BoxFit.contain,  // 이미지 크기가 텍스트에 맞게 조정되도록 설정
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 7),  // 하단에서 10px 패딩 추가
                    child:  AppText(
                      '처음 만난 날 설정하기',
                      style: TypoStyle.notoSansR19_1_4.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),




            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorName.pointBtnBg,
                foregroundColor: Colors.black87,
                minimumSize: Size(screenWidth * 0.84, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,  // 그림자 제거
                shadowColor: Colors.transparent,  // 그림자 색상을 투명으로 설정
                splashFactory: NoSplash.splashFactory,  // 클릭 시 물결 효과 제거
              ),
              child: AppText(
                _selectedDate == null
                    ? l10n.selectDate
                    : '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
                style: TypoStyle.notoSansSemiBold13_1_4.copyWith(
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
                color: ColorName.defaultGray,
              ),
              onPressed: () => _selectDate(context), // 날짜 선택 버튼 클릭 시 모달 호출
            ),
            const SizedBox(height: 13),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return ColorName.defaultGray;  // 버튼 비활성화 상태일 때
                    }
                    return ColorName.defaultBlack;  // 활성화 상태일 때
                  },
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.84, 58)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: _selectedDate == null ? null : _saveDateAndNavigate,
              child: AppText(
                l10n.confirmSetting,
                style: TypoStyle.notoSansSemiBold13_1_4.copyWith(
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
                color: _selectedDate == null
                    ? ColorName.pointBtnBg
                    : ColorName.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
