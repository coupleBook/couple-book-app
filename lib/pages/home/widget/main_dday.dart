import 'dart:io';

import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/data/remote/datasources/user_api/user_profile_api.dart';
import 'package:couple_book/data/repositories/my_image_storage_service.dart';
import 'package:couple_book/data/repositories/my_profile_service.dart';
import 'package:couple_book/data/repositories/user_profile_repository_impl.dart';
import 'package:couple_book/domain/usecases/auth/update_user_profile_image_use_case.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

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
  final logger = Logger();

  final userLocalDataSource = UserLocalDataSource.instance;
  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource.instance;
  final localUserLocalDataSource = LocalUserLocalDataSource.instance;

  final partnerLocalDataSource = PartnerLocalDataSource.instance;
  final partnerProfileImageLocalDataSource = PartnerProfileImageLocalDataSource.instance;

  final String todayDate = DateFormat('yy/MM/dd/EEEE', 'ko_KR').format(DateTime.now());
  final UpdateUserProfileImageUseCase updateUserProfileImageUseCase = UpdateUserProfileImageUseCase(
    UserProfileRepositoryImpl(
      userProfileApi: UserProfileApi(),
      myImageStorageService: MyImageStorageService(),
    ),
  );
  final myProfileService = MyProfileService();

  final userProfileApi = UserProfileApi();
  DateTime? anniversaryDate;
  String dday = '';

  late PermissionHandlerWidget permissionHandlerWidget;
  String leftProfileName = "Honey";
  String? leftProfileBirthdate = "";
  Gender? leftProfileGender;
  File? leftProfileImage;
  int leftProfileImageVersion = 0;

  String rightProfileName = "Honey";
  String rightProfileBirthdate = "";
  Gender? rightProfileGender;
  File? rightProfileImage;
  int rightProfileImageVersion = 0;

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
    await setMyInfo();
    await setPartnerInfo();

    calculateDday();
  }

  /// TODO: 처음만날날, D-day 계산 로직 서비스로 분리 예정
  /// getAnniversaryDate, calculateDday
  getAnniversaryDate() async {
    DateTime? anniversary = await localUserLocalDataSource.getAnniversaryToDatetime();
    setState(() {
      anniversaryDate = anniversary;
    });
  }

  void calculateDday() {
    if (anniversaryDate != null) {
      int calculateDday = DateTime.now().difference(anniversaryDate!).inDays + 1;
      setState(() {
        dday = calculateDday.toString();
      });
    }
  }

  setMyInfo() async {
    final user = await userLocalDataSource.getUser();

    if (user != null) {
      setState(() {
        leftProfileName = user.name;
        leftProfileBirthdate = user.birthday ?? '';
        leftProfileGender = user.gender;
      });
    }

    final userProfileImage = await userProfileImageLocalDataSource.getProfileImage();
    if (userProfileImage != null) {
      File imageFile = File(userProfileImage.filePath);

      if (imageFile.existsSync()) {
        setState(() {
          leftProfileImage = imageFile;
          leftProfileImageVersion = userProfileImage.version;
        });
      } else {
        setState(() {
          leftProfileImage = null;
        });
      }
    }
  }

  setPartnerInfo() async {
    final partnerInfo = await partnerLocalDataSource.getPartner();

    if (partnerInfo != null) {
      setState(() {
        rightProfileName = partnerInfo.name;
        rightProfileBirthdate = partnerInfo.birthday ?? '';
        rightProfileGender = partnerInfo.gender;
      });
    }

    final partnerProfileImage = await partnerProfileImageLocalDataSource.getPartnerProfileImage();
    if (partnerProfileImage != null) {
      File imageFile = File(partnerProfileImage.filePath);

      if (imageFile.existsSync()) {
        setState(() {
          rightProfileImage = imageFile;
          rightProfileImageVersion = partnerProfileImage.version;
        });
      } else {
        setState(() {
          rightProfileImage = null;
        });
      }
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
                  '처음 만난 날: ${anniversaryDate != null ? DateFormat('yyyy-MM-dd').format(anniversaryDate!) : ''}',
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
                                  child: Assets.icons.profileMaleContent.svg(width: 80, height: 80),
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
                          rightProfileBirthdate,
                          rightProfileImage != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(rightProfileImage!),
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: Assets.icons.profileFemaleContent.svg(width: 80, height: 80),
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

  Widget _buildProfileColumn(String name, String? birthdate, Widget profileIcon) {
    return Column(
      children: [
        profileIcon,
        const SizedBox(height: 8.0),
        AppText(
          name,
          style: TypoStyle.seoyunR19_1_4.copyWith(fontSize: 16),
        ),
        AppText(
          birthdate ?? '',
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
      final Gender? updatedGender = result['gender'];

      // 이름, 생일, 성별 변경 API 호출
      if (validUpdateProfile(updatedName, updatedBirthdate, updatedGender)) {
        final updateUserProfile = await userProfileApi.updateUserProfile(updatedName, updatedBirthdate, updatedGender);
        myProfileService.saveProfile(updateUserProfile);
      }

      // 이미지 변경 API 호출
      int updatedLeftProfileImageVersion = leftProfileImageVersion;
      if (updatedImage != null && updatedImage != leftProfileImage) {
        var profileImageModificationResponseDto = await updateUserProfileImageUseCase.execute(updatedImage);
        updatedLeftProfileImageVersion = profileImageModificationResponseDto.profileImageVersion;

        // 상태 업데이트
        setState(() {
          leftProfileImage = updatedImage;
          leftProfileImageVersion = updatedLeftProfileImageVersion;
        });
      }

      // 상태 업데이트
      setState(() {
        leftProfileName = updatedName;
        leftProfileBirthdate = updatedBirthdate;
        leftProfileGender = updatedGender;
      });
    } catch (e) {
      // 에러 처리 로직
      logger.e('Failed to update profile: $e');
    }
  }

  bool validUpdateProfile(updatedName, updatedBirthdate, updatedGender) {
    return updatedName != leftProfileName || updatedBirthdate != leftProfileBirthdate || updatedGender != leftProfileGender;
  }
}
