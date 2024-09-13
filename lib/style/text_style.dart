import 'package:flutter/material.dart';
import '../gen/colors.gen.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double letterSpacing;

  const AppText(
      this.text, {
        super.key,
        this.color = ColorName.black,
        this.style,
        this.textAlign,
        this.maxLines,
        this.letterSpacing = 0
      });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(color: color, fontFamily: 'Iseoyunchae', letterSpacing: letterSpacing);
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
  /// 이서윤체
  /// BOLD
  static const    seoyunB46_1_5 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 46,
    height: 1.5,
    fontWeight: FontWeight.bold,
  );

  static const seoyunB32_1_5 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 35,
    height: 1.5,
    fontWeight: FontWeight.bold,
  );

  static const seoyunB19_1_4 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 19.5,
    height: 1.4,
    fontWeight: FontWeight.bold,
  );

  /// REGULAR
  static const seoyunR46_1_5 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 46,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const seoyunR32_1_4 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 32,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const seoyunR26_1_4 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 26,
    height: 1.4,
    fontWeight: FontWeight.w100,
  );

  static const seoyunR19_1_4 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 19.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const seoyunR10_1_4 = TextStyle(
    fontFamily: 'Iseoyunchae',
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  /// NotoS ansKR
  /// Bold
  static const notoSansBold22 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.2, // 자간을 줄이기 위해 음수 값 설정
  );

  static const notoSansSemiBold22 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 26,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4, // 자간을 줄이기 위해 음수 값 설정
  );

  /// Regular
  static const notoSansR19_1_4 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 19,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const notoSansR13_1_4 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const notoSansR14_1_4 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 13.5,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
  );
}