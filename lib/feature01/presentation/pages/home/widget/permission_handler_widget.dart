import 'dart:io';

import 'package:couple_book/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

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
  State<PermissionHandlerWidget> createState() => PermissionHandlerWidgetState();
}

class PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestPermissions(context);
    });
  }

  Future<void> checkAndRequestPermissions(BuildContext context) async {
    try {
      PermissionStatus status = await Permission.photos.status;

      if (Platform.isIOS) {
        PermissionStatus status = await Permission.photos.request();
        if (status.isGranted || status.isLimited) {
          if (context.mounted) {
            widget.onPermissionGranted();
          }
        } else if (status.isPermanentlyDenied && widget.callLocation == 'PHOTO_ACTION') {
          if (context.mounted) {
            _showSettingsDialog(context);
          }
        }
        return;
      }

      if (status.isGranted || status.isLimited) {
        if (context.mounted) {
          widget.onPermissionGranted();
        }
      } else if (status.isDenied) {
        if (context.mounted) {
          _showPermissionRequestPopup(context);
        }
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showSettingsDialog(context);
        }
      }
    } catch (e) {
      logger.e('권한 요청 중 오류 발생: $e');
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library, color: Colors.blueAccent, size: 40),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${widget.appName}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
                ),
                TextSpan(
                  text: l10n.accessPhotoPopupTitle,
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildPermissionButton(
                context,
                onPressed: () async {
                  Navigator.of(context).pop();
                  PermissionStatus status = await Permission.photos.request();

                  if (status.isGranted || status.isLimited) {
                    widget.onPermissionGranted();
                  } else if (status.isPermanentlyDenied) {
                    _showSettingsDialog(context);
                  }
                },
                text: l10n.fullAccess,
                textColor: Colors.blueAccent,
              ),
              _buildPermissionButton(
                context,
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onPermissionGranted();
                },
                text: l10n.limitedAccess,
              ),
              _buildPermissionButton(
                context,
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.accessDeniedGallery)),
                  );
                },
                text: l10n.accessDenied,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionButton(BuildContext context, {required VoidCallback onPressed, required String text, Color textColor = Colors.white}) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
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
