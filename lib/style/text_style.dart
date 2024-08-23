import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';


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
    final defaultStyle = TextStyle(color: color);
    final effectiveStyle = style?.copyWith(color: color) ?? defaultStyle;

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}


class TypoStyle {
  /// BOLD
  static const seoyunB46_1_5 = TextStyle(
    fontSize: 46,
    height: 1.5,
    fontWeight: FontWeight.bold,
  );

  /// REGULAR
  static const seoyunR32_1_4 = TextStyle(
    fontSize: 32,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const seoyunR26_1_4 = TextStyle(
    fontSize: 26,
    height: 1.4,
    fontWeight: FontWeight.w100,
  );

  static const seoyunR19_1_4 = TextStyle(
    fontSize: 19.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );
}