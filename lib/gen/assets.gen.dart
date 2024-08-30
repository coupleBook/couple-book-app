/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsColorGen {
  const $AssetsColorGen();

  /// File path: assets/color/colors.xml
  String get colors => 'assets/color/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// =================== Background ===================
  SvgGenImage get bgSplash => const SvgGenImage('assets/bgImgs/splash_page.svg');


  /// =================== Contents ===================
  SvgGenImage get heartContent => const SvgGenImage('assets/contents/heart01.svg');
  SvgGenImage get heartBoxContent => const SvgGenImage('assets/contents/heart_box.svg');
  SvgGenImage get homeBoxContent => const SvgGenImage('assets/contents/home_box.svg');
  SvgGenImage get lineContent => const SvgGenImage('assets/contents/line.svg');
  SvgGenImage get logoContent => const SvgGenImage('assets/contents/logo.svg');
  SvgGenImage get miniHeartContent => const SvgGenImage('assets/contents/mini_heart.svg');
  SvgGenImage get profileFemaleContent => const SvgGenImage('assets/contents/profile_female.svg');
  SvgGenImage get profileMaleContent => const SvgGenImage('assets/contents/profile_male.svg');


  /// =================== Icons ===================
  SvgGenImage get c_heartIcon => const SvgGenImage('assets/icons/c_heart_icon.svg');
  SvgGenImage get c_googleIcon => const SvgGenImage('assets/icons/c_google_icon.svg');
  SvgGenImage get c_kakaoIcon => const SvgGenImage('assets/icons/g_kakao_icon.svg');
  SvgGenImage get c_naverIcon => const SvgGenImage('assets/icons/g_naver_icon.svg');

  SvgGenImage get botLineIcon => const SvgGenImage('assets/icons/bot_line.svg');

  /// Non-selected
  SvgGenImage get challengeIcon_off => const SvgGenImage('assets/icons/challenge_off.svg');
  SvgGenImage get coupleInfo_off => const SvgGenImage('assets/icons/couple_info_off.svg');
  SvgGenImage get homeIcon_off => const SvgGenImage('assets/icons/home_off.svg');
  SvgGenImage get moreIcon_off => const SvgGenImage('assets/icons/more_off.svg');
  SvgGenImage get noticeIcon_n => const SvgGenImage('assets/icons/notice_n.svg');
  SvgGenImage get settingIcon_n => const SvgGenImage('assets/icons/setting_n.svg');
  SvgGenImage get timelineIcon_off => const SvgGenImage('assets/icons/timeline_off.svg');

  /// Selected
  SvgGenImage get homeIcon_on => const SvgGenImage('assets/icons/home_on.svg');
  SvgGenImage get challengeIcon_on => const SvgGenImage('assets/icons/challenge_on.svg');
  SvgGenImage get coupleInfo_on => const SvgGenImage('assets/icons/couple_info_on.svg');
  SvgGenImage get moreIcon_on => const SvgGenImage('assets/icons/more_on.svg');
  SvgGenImage get timelineIcon_on => const SvgGenImage('assets/icons/timeline_on.svg');

  /// List of all assets
  List<SvgGenImage> get values =>
      [
        /// Background
          bgSplash
        /// CONTENTS
        , heartContent
        , heartBoxContent
        , homeBoxContent
        , lineContent
        , logoContent
        , miniHeartContent
        , profileFemaleContent
        , profileMaleContent
        /// ICONS
        , c_heartIcon
        , c_googleIcon
        , c_kakaoIcon
        , c_naverIcon
        , botLineIcon
        /// ICONS - Non-selected
        , homeIcon_off
        , challengeIcon_off
        , coupleInfo_off
        , moreIcon_off
        , noticeIcon_n
        , settingIcon_n
        , timelineIcon_off
        /// ICONS - selected
        , homeIcon_on
        , challengeIcon_on
        , coupleInfo_on
        , moreIcon_on
        , timelineIcon_on
      ];
}

class Assets {
  Assets._();

  static const $AssetsColorGen color = $AssetsColorGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
