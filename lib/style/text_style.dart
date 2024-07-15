import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const AppText(
      this.text, {
        super.key,
        this.color = ColorName.black,
        this.style,
        this.textAlign,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TypoStyle {
  static const titleXLarge = TextStyle(
    fontSize: 24,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );
  static const titleLarge = TextStyle(
    fontSize: 22,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );
  static const titleMedium = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );
  static const bodyMedium = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const bodySmall = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const descriptionSmall = TextStyle(
    fontSize: 12,
    height: 1.8,
    fontWeight: FontWeight.w400,
  );
  static const buttonLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );
}