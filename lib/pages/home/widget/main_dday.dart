// main_dday.dart

import 'package:COUPLE_BOOK/gen/colors.gen.dart';
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
    return SingleChildScrollView(
      child: Container(
      width: MediaQuery.of(context).size.width, // 화면 전체 너비 사용
      alignment: Alignment.topCenter, // 가로 중앙 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 상단에 붙이기업
          crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
          children: [
            // D-day Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
              constraints: BoxConstraints(maxWidth: 350),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Couple Book Section
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Assets.icons.logoContent.svg(
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(width: 8),
                            Assets.icons.lineContent.svg(
                              height: 80,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  // Text Section
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          today,
                          style: TypoStyle.seoyunR19_1_4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: AppText(
                                '$dday',
                                style: TypoStyle.seoyunB19_1_4,
                              ),
                            ),
                            AppText(
                              '일째',
                              style: TypoStyle.seoyunR19_1_4,
                            ),
                            SizedBox(width: 4.0),
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Character and Date Section
            // SizedBox(height: 30.0), // 간격 최소화
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              constraints: BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // 위로 붙이기
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Character Box
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Assets.icons.homeBoxContent.svg(
                        width: 539,
                        height: 260,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Characters Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Assets.icons.profileMaleContent.svg(
                                    width: 80,
                                    height: 80,
                                  ),
                                  AppText(
                                    '요셉',
                                    style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(width: 4.0), // 간격 최소화
                              Icon(
                                Icons.favorite,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4.0), // 간격 최소화
                              Column(
                                children: [
                                  Assets.icons.profileFemaleContent.svg(
                                    width: 80,
                                    height: 80,
                                  ),
                                  AppText(
                                    '지수',
                                    style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 바로 아래 텍스트 위치 조정, 간격 최소화
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.heartBoxContent.svg(
                        width: 18,
                        height: 17,
                      ),
                      SizedBox(width: 4.0),
                      AppText(
                        '처음 만난 날: 23/11/25/토요일',
                        style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 14),
                        color: ColorName.defaultGray,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
