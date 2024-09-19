import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import 'profile_popup.dart'; // 새로 만든 파일을 import
import 'package:couple_book/gen/colors.gen.dart';
import '../../../../gen/assets.gen.dart';
import '../../../style/text_style.dart';
import 'permission_handler_widget.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; // 권한 체크 패키지 추가

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
  late PermissionHandlerWidget permissionHandlerWidget;
  String leftProfileName = "요셉";
  String leftProfileBirthdate = "97/08/19";
  File? leftProfileImage;

  String rightProfileName = "지수";
  String rightProfileBirthdate = "95/12/14";
  File? rightProfileImage;

  @override
  void initState() {
    super.initState();
    permissionHandlerWidget = PermissionHandlerWidget(
      onPermissionGranted: () {
        /// print('Permission granted');
      },
      appName: l10n.appName,
      callLocation: 'HOME',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.backgroundColor,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PermissionHandlerWidget(
            onPermissionGranted: () {
            /// print('Permission granted');
            },
            appName: l10n.appName,
            callLocation: 'HOME',
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: AppText(
              widget.today,
              style: TypoStyle.notoSansR19_1_4,
            ),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.heartContent.svg(
                  width: 43,
                  height: 33,
                ),
                const SizedBox(width: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      '${widget.dday}',
                      style: TypoStyle.seoyunB32_1_5,
                    ),
                    const AppText(
                      '일째',
                      style: TypoStyle.seoyunB32_1_5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
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
          const SizedBox(height: 70.0),
          Center(
            child: Container(
              width: 320,
              height: 240,
              decoration: BoxDecoration(
                color: ColorName.backgroundColor,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var result = await showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.86,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: ProfilePopupForm(
                                    name: leftProfileName,
                                    birthdate: leftProfileBirthdate,
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
                        child: _buildProfileColumn(
                          leftProfileName,
                          leftProfileBirthdate,
                          leftProfileImage != null
                              ? CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(leftProfileImage!),
                            backgroundColor: Colors.transparent,
                          )
                              : CircleAvatar(
                            radius: 40,
                            child: Assets.icons.profileMaleContent.svg(width: 80, height: 80),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Assets.icons.miniHeartContent.svg(
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 20.0),
                      GestureDetector(
                        onTap: () async {
                          var result = await showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.86,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: ProfilePopupForm(
                                    name: rightProfileName,
                                    birthdate: rightProfileBirthdate,
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
                        child: _buildProfileColumn(
                          rightProfileName,
                          rightProfileBirthdate,
                          rightProfileImage != null
                              ? CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(rightProfileImage!),
                            backgroundColor: Colors.transparent,
                          )
                              : CircleAvatar(
                            radius: 40,
                            child: Assets.icons.profileFemaleContent.svg(width: 80, height: 80),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
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
