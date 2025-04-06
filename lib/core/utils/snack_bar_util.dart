import 'package:flutter/material.dart';

enum SnackType { normal, error, success }

class SnackBarUtil {
  static void show(BuildContext context, String message, {SnackType type = SnackType.normal}) {
    Color background = switch (type) {
      SnackType.success => Colors.green.shade700,
      SnackType.error => Colors.red.shade700,
      _ => Colors.black.withOpacity(0.9),
    };

    final snackBar = SnackBar(
      backgroundColor: background,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
