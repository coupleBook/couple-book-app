import 'dart:io';

import 'package:couple_book/feature/auth/user_profile_service.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../gen/assets.gen.dart';
import '../../../core/utils/security/couple_security.dart';
import '../../../feature/auth/image_storage_service.dart';
import '../../../core/l10n/l10n.dart';
import '../../../style/text_style.dart';
import 'permission_handler_widget.dart';
import 'profile_popup.dart'; // 새로 만든 파일을 import

class MainDdayView extends StatefulWidget {
  const MainDdayView({
    super.key,
  });

  @override
  MainDdayViewState createState() => MainDdayViewState();
}

class MainDdayViewState extends State<MainDdayView> {
  final ImageStorageService imageStorageService = ImageStorageService();
  final logger = Logger();
  final String todayDate =
      DateFormat('yy/MM/dd/EEEE', 'ko_KR').format(DateTime.now());
  final UserProfileService userProfileService = UserProfileService();
  String anniversaryDate = '';
  String dday = '';

  late PermissionHandlerWidget permissionHandlerWidget;
  String leftProfileName = "Honey";
  String? leftProfileBirthdate = "";
  String? leftProfileGender;
  File? leftProfileImage;
  int? leftProfileImageVersion;

  String rightProfileName = "Honey";
  String? rightProfileBirthdate = "";
  String? rightProfileGender;
  File? rightProfileImage;
  int? rightProfileImageVersion;

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    permissionHandlerWidget = PermissionHandlerWidget(
      onPermissionGranted: () {
        /// print('Permission granted');
      },
      appName: l10n.appName,
      callLocation: 'HOME',
    );
  }

  _asyncMethod() async {
    await getAnniversaryDate();
    await getMyData();
    calculateDday();
  }

  /// TODO: 처음만날날, D-day 계산 로직 서비스로 분리 예정
  /// getAnniversaryDate, calculateDday
  getAnniversaryDate() async {
    String anniversary = await getAnniversary();
    setState(() {
      anniversaryDate = anniversary;
    });
  }

  void calculateDday() {
    if (anniversaryDate.isNotEmpty) {
      final anniversary = DateFormat('yyyy-MM-dd').parse(anniversaryDate);
      int calculateDday = DateTime.now().difference(anniversary).inDays + 1;
      dday = calculateDday.toString();
    }
  }

  getMyData() async {
    final myInfo = await getMyInfo();
    final profileImage = await imageStorageService.getImage();
    if (myInfo != null) {
      leftProfileName = myInfo.name;
      leftProfileBirthdate = myInfo.birthday!;
      leftProfileGender = myInfo.gender;
      leftProfileImage = profileImage;
      leftProfileImageVersion = myInfo.profileImageVersion!;
    }
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
              todayDate,
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
                      dday,
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
                  '처음 만난 날: $anniversaryDate',
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
                                    gender: leftProfileGender,
                                    selectedImage: leftProfileImage,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result != null) {
                            Future.microtask(() async {
                              await _handleMyProfileUpdate(result);
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
                                  backgroundColor: Colors.transparent,
                                  child: Assets.icons.profileMaleContent
                                      .svg(width: 80, height: 80),
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
                        // onTap: () async {
                        //   var result = await showModalBottomSheet(
                        //     context: context,
                        //     backgroundColor: Colors.transparent,
                        //     isScrollControlled: true,
                        //     builder: (BuildContext context) {
                        //       return FractionallySizedBox(
                        //         heightFactor: 0.86,
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.only(
                        //               topLeft: Radius.circular(20.0),
                        //               topRight: Radius.circular(20.0),
                        //             ),
                        //           ),
                        //           child: ProfilePopupForm(
                        //             name: rightProfileName,
                        //             birthdate: rightProfileBirthdate,
                        //             gender: rightProfileGender,
                        //             selectedImage: rightProfileImage,
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        //   if (result != null) {
                        //     setState(() {
                        //       rightProfileName = result['name'];
                        //       rightProfileBirthdate = result['birthdate'];
                        //       rightProfileImage = result['image'];
                        //     });
                        //   }
                        // },
                        child: _buildProfileColumn(
                          rightProfileName,
                          rightProfileBirthdate!,
                          rightProfileImage != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      FileImage(rightProfileImage!),
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: Assets.icons.profileFemaleContent
                                      .svg(width: 80, height: 80),
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

  Widget _buildProfileColumn(
      String name, String? birthdate, Widget profileIcon) {
    return Column(
      children: [
        profileIcon,
        const SizedBox(height: 8.0),
        AppText(
          name,
          style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
        ),
        AppText(
          birthdate!,
          style: TypoStyle.notoSansR13_1_4.copyWith(fontSize: 10),
          color: ColorName.defaultGray,
        ),
      ],
    );
  }

  Future<void> _handleMyProfileUpdate(Map<String, dynamic> result) async {
    try {
      final String updatedName = result['name'];
      final String? updatedBirthdate = result['birthdate'];
      final File? updatedImage = result['image'];
      final String? updatedGender = result['gender'];

      // 이름, 생일, 성별 변경 API 호출
      if (validUpdateProfile(updatedName, updatedBirthdate, updatedGender)) {
        await userProfileService.updateUserProfile(
          updatedName,
          updatedBirthdate,
          updatedGender,
        );
      }

      // 이미지 변경 API 호출
      int updatedLeftProfileImageVersion = leftProfileImageVersion!;
      if (updatedImage != null && updatedImage != leftProfileImage) {
        var profileImageModificationResponseDto =
            await userProfileService.updateUserProfileImage(updatedImage);
        updatedLeftProfileImageVersion =
            profileImageModificationResponseDto.profileImageVersion;
      }

      // 상태 업데이트
      setState(() {
        leftProfileName = updatedName;
        leftProfileBirthdate = updatedBirthdate;
        leftProfileGender = updatedGender;
        leftProfileImage = updatedImage;
        leftProfileImageVersion = updatedLeftProfileImageVersion;
      });
    } catch (e) {
      // 에러 처리 로직
      logger.e('Failed to update profile: $e');
    }
  }

  bool validUpdateProfile(updatedName, updatedBirthdate, updatedGender) {
    return updatedName != leftProfileName ||
        updatedBirthdate != leftProfileBirthdate ||
        updatedGender != leftProfileGender;
  }
}
