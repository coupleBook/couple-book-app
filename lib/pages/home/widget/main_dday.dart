import 'package:flutter/material.dart';
import 'profile_popup.dart'; // 새로 만든 파일을 import
import 'package:couple_book/gen/colors.gen.dart';
import '../../../../gen/assets.gen.dart';
import '../../../style/text_style.dart';

class MainDdayView extends StatelessWidget {
  final String today;
  final int dday;

  const MainDdayView({
    super.key,
    required this.today,
    required this.dday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.backgroundColor, // 배경색 설정
      width: MediaQuery.of(context).size.width, // 화면 전체 너비 사용
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // 상하 패딩 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
        children: [
          const SizedBox(height: 24.0),

          // 오늘 날짜 텍스트
          Padding(
            padding: const EdgeInsets.only(left: 20.0), // 왼쪽 패딩 추가로 오른쪽으로 이동
            child: AppText(
              today,
              style: TypoStyle.notoSansR19_1_4,
            ),
          ),
          const SizedBox(height: 2.0), // 날짜와 하트+일째 사이 간격

          // 하트와 D-day 정보가 있는 Row
          Padding(
            padding: const EdgeInsets.only(left: 20.0), // 왼쪽 패딩 추가로 오른쪽으로 이동
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.heartContent.svg(
                  width: 43,
                  height: 33,
                ),
                const SizedBox(width: 4.0), // 하트와 D-day 사이 간격
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      '$dday', // D-day 숫자
                      style: TypoStyle.seoyunB32_1_5, // dday에 대한 스타일
                    ),
                    const AppText(
                      '일째', // "일째" 텍스트
                      style: TypoStyle.seoyunB32_1_5, // "일째"에 대한 스타일
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0), // 텍스트 간격 조정

          Padding(
            padding: const EdgeInsets.only(left: 20.0), // 왼쪽 패딩 추가로 오른쪽으로 이동
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0), // 아래쪽으로 2.0의 패딩을 추가
                  child: Assets.icons.bookIcon.svg(
                    width: 12,
                    height: 11,
                  ),
                ),
                const SizedBox(width: 4.0),
                AppText(
                  '처음 만난 날: 23/11/25/금요일',
                  style: TypoStyle.notoSansR19_1_4.copyWith(fontSize: 12),
                  color: ColorName.defaultGray,
                ),
              ],
            ),
          ),
          const SizedBox(height: 70.0), // 상단 내용과 프로필 박스 사이 간격

          // 프로필과 팝업 연동
          Center(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent, // 투명 배경
                  isScrollControlled: true, // 스크롤 가능하도록 설정
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.86, // 세로 길이를 화면의 86%로 설정
                      child: Container(
                        width: MediaQuery.of(context).size.width, // 가로 길이를 화면에 꽉 차게 설정
                        decoration: const BoxDecoration(
                          color: Colors.white, // 배경색
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ), // 팝업 상단에 둥근 모서리 적용
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 자식의 크기에 맞게 Column 크기를 설정
                            children: [
                              // 팝업 안의 폼 부분
                              ProfilePopupForm(), // 여기에 실제 폼을 넣습니다.
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

              },
              child: Container(
                width: 320, // 너비 조정
                height: 240, // 높이 조정
                decoration: BoxDecoration(
                  color: ColorName.backgroundColor, // 배경색 설정
                  border: Border.all(
                    color: Colors.black, // 외곽선 색상 설정
                    width: 1.0, // 외곽선 두께
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                      children: [
                        _buildProfileColumn('요셉', '97/08/19', Assets.icons.profileMaleContent.svg(width: 80, height: 80)),
                        const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                        Assets.icons.miniHeartContent.svg(
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                        _buildProfileColumn('지수', '95/12/14', Assets.icons.profileFemaleContent.svg(width: 80, height: 80)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 정보 빌드 메소드
  Widget _buildProfileColumn(String name, String birthdate, Widget profileIcon) {
    return Column(
      children: [
        profileIcon,
        const SizedBox(height: 8.0),
        AppText(
          name,
          style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
        ),
        AppText(
          birthdate,
          style: TypoStyle.notoSansR13_1_4.copyWith(fontSize: 10),
          color: ColorName.defaultGray,
        ),
      ],
    );
  }
}
