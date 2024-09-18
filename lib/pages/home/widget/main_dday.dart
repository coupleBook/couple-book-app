import 'package:flutter/material.dart';
import 'profile_popup.dart'; // 새로 만든 파일을 import
import 'package:couple_book/gen/colors.gen.dart';
import '../../../../gen/assets.gen.dart';
import '../../../style/text_style.dart';
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
  String leftProfileName = "요셉";
  String leftProfileBirthdate = "97/08/19";
  File? leftProfileImage;

  String rightProfileName = "지수";
  String rightProfileBirthdate = "95/12/14";
  File? rightProfileImage;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions(); // 화면 진입 시 권한 체크 및 요청
  }

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied || await Permission.manageExternalStorage.isDenied) {
        _showPermissionRequestPopup();
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.isDenied) {
        _showPermissionRequestPopup();
      }
    }
  }

  void _showPermissionRequestPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildPermissionPopup();
      },
    );
  }

  Widget _buildPermissionPopup() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: ColorName.defaultBlack,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library,
            color: Colors.blueAccent,
            size: 40,
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'COUPLE BOOK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: ColorName.white,
                  ),
                ),
                TextSpan(
                  text: '에서 기기의 사진과 동영상에\n액세스하도록 허용하시겠습니까?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // 팝업 닫기
                    await _requestPermissionAndPickImage(); // 실제 권한 요청 수행
                  },
                  child: const Text(
                    '허용',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('갤러리 접근 권한이 거부되었습니다.')),
                    );
                  },
                  child: const Text(
                    '허용 안함',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissionAndPickImage() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted) {
        // 권한이 허용되면 이미지를 선택하거나 다른 작업 수행
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리 접근 권한이 필요합니다.')),
        );
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        // 권한이 허용되면 이미지를 선택하거나 다른 작업 수행
      } else if (await Permission.photos.isDenied || await Permission.photos.isPermanentlyDenied) {
        // 권한이 거부되거나 영구적으로 거부된 경우 설정 페이지로 안내
        _showSettingsDialog();
      }
    }
  }

// 설정 페이지로 안내하는 다이얼로그
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('권한 설정 필요'),
          content: const Text('갤러리 접근을 위해 설정에서 권한을 허용해 주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // 설정 페이지로 이동
                Navigator.of(context).pop();
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        );
      },
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
