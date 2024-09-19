import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final VoidCallback onPermissionGranted;
  final String appName;
  final String callLocation;

  const PermissionHandlerWidget({
    Key? key,
    required this.onPermissionGranted,
    required this.appName,
    required this.callLocation,
  }) : super(key: key);

  @override
  _PermissionHandlerWidgetState createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestPermissions(context);
    });
  }

  Future<void> checkAndRequestPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;

    if(Platform.isIOS) {
      PermissionStatus status = await Permission.photos.request();
      if(status.isGranted) {
        widget.onPermissionGranted();
      } else if (status.isLimited) {
        // 제한된 접근이 허용된 경우
        widget.onPermissionGranted();
      } else if (status.isPermanentlyDenied && widget.callLocation == 'PHOTO_ACTION') {
        // 사용자가 허용 안함을 선택한 경우 설정 페이지로 이동하는 다이얼로그 표시
        _showSettingsDialog(context);
      }

      return;
    }

    if (status.isGranted) {
      // 전체 접근이 허용된 경우
      widget.onPermissionGranted();
    } else if (status.isDenied) {
      // 권한이 거부된 경우
      _showPermissionRequestPopup(context);
    } else if (status.isLimited) {
      // 제한된 접근이 허용된 경우
      widget.onPermissionGranted();
    } else if (status.isPermanentlyDenied) {
      // 사용자가 허용 안함을 선택한 경우 설정 페이지로 이동하는 다이얼로그 표시
      _showSettingsDialog(context);
    }
  }

  void _showPermissionRequestPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildPermissionPopup(context);
      },
    );
  }

  Widget _buildPermissionPopup(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.black,
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
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${widget.appName}\n',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(
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
                    Navigator.of(context).pop();
                    PermissionStatus status = await Permission.photos.request();

                    if (status.isGranted) {
                      widget.onPermissionGranted(); // 전체 접근이 허용된 경우 처리
                    } else if (status.isLimited) {
                      widget.onPermissionGranted(); // 제한된 접근이 허용된 경우 처리
                    } else if (status.isPermanentlyDenied) {
                      _showSettingsDialog(context);
                    }
                  },
                  child: const Text(
                    '전체 접근 허용',
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
                    Navigator.of(context).pop();
                    widget.onPermissionGranted(); // 제한된 접근이 허용된 경우 바로 처리
                  },
                  child: const Text(
                    '제한된 접근 허용',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('갤러리 접근 권한이 거부되었습니다.')),
                    );
                  },
                  child: const Text(
                    '허용 안 함',
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

  void _showSettingsDialog(BuildContext context) {
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
                openAppSettings();
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
    return const SizedBox.shrink();
  }
}
