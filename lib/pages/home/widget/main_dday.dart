import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
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

          // 네모 박스 (이미지)와 프로필 정보
          Center(
            child: Container(
              width: 320, // 너비 조정
              height: 240, // 높이 조정
              decoration: BoxDecoration(
                color: ColorName.backgroundColor, // 배경색 설정
                border: Border.all(
                  color: Colors.black, // 외곽선 색상 설정
                  width: 1.0, // 외곽선 두께
                ),
                boxShadow: const [
                  BoxShadow(
                    color: ColorName.defaultBlack,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      Column(
                        children: [
                          Assets.icons.profileMaleContent.svg(
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 8.0),
                          AppText(
                            '요셉',
                            style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
                          ),
                          AppText(
                            '97/08/19',
                            style: TypoStyle.notoSansR13_1_4.copyWith(fontSize: 10),
                            color: ColorName.defaultGray,
                          ),
                        ],
                      ),
                      const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                      Assets.icons.miniHeartContent.svg(
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: [
                          Assets.icons.profileFemaleContent.svg(
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 8.0),
                          AppText(
                            '지수',
                            style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
                          ),
                          AppText(
                            '95/12/14',
                            style: TypoStyle.notoSansR13_1_4.copyWith(fontSize: 10),
                            color: ColorName.defaultGray,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}