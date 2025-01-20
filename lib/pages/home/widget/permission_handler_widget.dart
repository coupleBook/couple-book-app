import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/l10n/l10n.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final VoidCallback onPermissionGranted;
  final String appName;
  final String callLocation;

  const PermissionHandlerWidget({
    super.key,
    required this.onPermissionGranted,
    required this.appName,
    required this.callLocation,
  });

  @override
  PermissionHandlerWidgetState createState() => PermissionHandlerWidgetState();
}

class PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestPermissions(context);
    });
  }

  Future<void> checkAndRequestPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;

    if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        if (context.mounted) {
          widget.onPermissionGranted();
        }
      } else if (status.isPermanentlyDenied &&
          widget.callLocation == 'PHOTO_ACTION') {
        // 사용자가 허용 안함을 선택한 경우 설정 페이지로 이동하는 다이얼로그 표시
        if (context.mounted) {
          _showSettingsDialog(context);
        }
      }
      return;
    }

    // 전체 접근이 허용된 경우
    if (status.isGranted || status.isLimited) {
      if (context.mounted) {
        widget.onPermissionGranted();
      }
      // 권한이 거부된 경우
    } else if (status.isDenied) {
      if (context.mounted) {
        _showPermissionRequestPopup(context);
      }
      // 사용자가 허용 안함을 선택한 경우 설정 페이지로 이동하는 다이얼로그 표시
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(context);
      }
    }
  }

  void _showPermissionRequestPopup(BuildContext context) {
    if (!context.mounted) return;
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
                TextSpan(
                  text: l10n.accessPhotoPopupTitle,
                  style: const TextStyle(
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
                  child: Text(
                    l10n.fullAccess,
                    style: const TextStyle(
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
                  child: Text(
                    l10n.limitedAccess,
                    style: const TextStyle(
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
                      SnackBar(content: Text(l10n.accessDeniedGallery)),
                    );
                  },
                  child: Text(
                    l10n.accessDenied,
                    style: const TextStyle(
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
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.needAccessPermission),
          content: Text(l10n.accessPermissionDescription),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.moveToSetting),
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
