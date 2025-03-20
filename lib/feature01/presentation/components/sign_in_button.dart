import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;

  const SignInButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  static const double _buttonWidth = 320;
  static const double _buttonHeight = 58;
  static const double _buttonBorderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: const Size(_buttonWidth, _buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonBorderRadius),
        ),
        shadowColor: const Color(0x4D485629),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 12, child: icon),
          const SizedBox(width: 8),
          Text(text, style: TypoStyle.notoSansR14_1_4.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
