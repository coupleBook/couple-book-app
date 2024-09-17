import 'package:flutter/material.dart';
import 'profile_popup.dart'; // 새로 만든 파일을 import
import 'package:couple_book/gen/colors.gen.dart';
import '../../../../gen/assets.gen.dart';
import '../../../style/text_style.dart';
import 'dart:io';

class MainDdayView extends StatefulWidget {
  final String today;
  final int dday;

  const MainDdayView({
    super.key,
    required this.today,
    required this.dday,
  });

  @override
  _MainDdayViewState createState() => _MainDdayViewState();
}

class _MainDdayViewState extends State<MainDdayView> {
  String leftProfileName = "요셉";
  String leftProfileBirthdate = "97/08/19";
  File? leftProfileImage;

  String rightProfileName = "지수";
  String rightProfileBirthdate = "95/12/14";
  File? rightProfileImage;

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
              widget.today,
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
                      '${widget.dday}', // D-day 숫자
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
                      GestureDetector(
                        onTap: () async {
                          var result = await showModalBottomSheet(
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
                                  child: ProfilePopupForm(
                                    name: leftProfileName, // 왼쪽 프로필의 이름
                                    birthdate: leftProfileBirthdate, // 왼쪽 프로필의 생년월일
                                    selectedImage: leftProfileImage,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              leftProfileName = result['name'];
                              leftProfileBirthdate = result['birthdate'];
                              leftProfileImage = result['image'];
                            });
                          }
                        },
                        child: _buildProfileColumn(leftProfileName, leftProfileBirthdate, leftProfileImage != null
                            ? CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(leftProfileImage!), // 이미지 파일 원형으로 설정
                          backgroundColor: Colors.transparent,
                        )
                            : CircleAvatar(
                          radius: 40,
                          child: Assets.icons.profileMaleContent.svg(width: 80, height: 80),
                          backgroundColor: Colors.transparent,
                        )),
                      ),
                      const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                      Assets.icons.miniHeartContent.svg(
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 20.0), // 두 프로필 아이콘 사이의 간격
                      GestureDetector(
                        onTap: () async {
                          var result = await showModalBottomSheet(
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
                                  child: ProfilePopupForm(
                                    name: rightProfileName, // 오른쪽 프로필의 이름
                                    birthdate: rightProfileBirthdate, // 오른쪽 프로필의 생년월일
                                    selectedImage: rightProfileImage,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              rightProfileName = result['name'];
                              rightProfileBirthdate = result['birthdate'];
                              rightProfileImage = result['image'];
                            });
                          }
                        },
                        child: _buildProfileColumn(rightProfileName, rightProfileBirthdate, rightProfileImage != null
                            ? CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(rightProfileImage!), // 이미지 파일 원형으로 설정
                          backgroundColor: Colors.transparent,
                        )
                            : CircleAvatar(
                          radius: 40,
                          child: Assets.icons.profileFemaleContent.svg(width: 80, height: 80),
                          backgroundColor: Colors.transparent,
                        )),
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

// 프로필 정보 빌드 메소드
  Widget _buildProfileColumn(String name, String birthdate, Widget profileIcon) {
    return Column(
      children: [
        profileIcon, // 원형 프로필 이미지
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
