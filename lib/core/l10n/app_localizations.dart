import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'COUPLE BOOK'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @coupleInfo.
  ///
  /// In ko, this message translates to:
  /// **'커플정보'**
  String get coupleInfo;

  /// No description provided for @timeline.
  ///
  /// In ko, this message translates to:
  /// **'타임라인'**
  String get timeline;

  /// No description provided for @challenge.
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get challenge;

  /// No description provided for @more.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get more;

  /// No description provided for @loginPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'커플북과 함께 우리의\n소중한 추억을 기록해요.'**
  String get loginPageTitle;

  /// No description provided for @loginPageSubTitle.
  ///
  /// In ko, this message translates to:
  /// **'SNS 계정으로 간편 가입하기'**
  String get loginPageSubTitle;

  /// No description provided for @signInGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글 계정으로 가입하기'**
  String get signInGoogle;

  /// No description provided for @signInNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버로 가입하기'**
  String get signInNaver;

  /// No description provided for @signInKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오톡으로 가입하기'**
  String get signInKakao;

  /// No description provided for @logoutGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글 로그아웃'**
  String get logoutGoogle;

  /// No description provided for @logoutNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버 로그아웃'**
  String get logoutNaver;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get name;

  /// No description provided for @limitTextPlaceHolder.
  ///
  /// In ko, this message translates to:
  /// **'2~20자 이내여야 합니다.'**
  String get limitTextPlaceHolder;

  /// No description provided for @birthday.
  ///
  /// In ko, this message translates to:
  /// **'생일'**
  String get birthday;

  /// No description provided for @selectDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택해 주세요.'**
  String get selectDate;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장하기'**
  String get save;

  /// No description provided for @typingName.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요.'**
  String get typingName;

  /// No description provided for @accessPhotoPopupTitle.
  ///
  /// In ko, this message translates to:
  /// **'에서 기기의 사진과 동영상에\n액세스하도록 허용하시겠습니까?'**
  String get accessPhotoPopupTitle;

  /// No description provided for @fullAccess.
  ///
  /// In ko, this message translates to:
  /// **'전체 접근 허용'**
  String get fullAccess;

  /// No description provided for @limitedAccess.
  ///
  /// In ko, this message translates to:
  /// **'제한된 접근 허용'**
  String get limitedAccess;

  /// No description provided for @accessDenied.
  ///
  /// In ko, this message translates to:
  /// **'허용 안 함'**
  String get accessDenied;

  /// No description provided for @accessDeniedGallery.
  ///
  /// In ko, this message translates to:
  /// **'갤러리 접근 권한이 거부되었습니다.'**
  String get accessDeniedGallery;

  /// No description provided for @needAccessPermission.
  ///
  /// In ko, this message translates to:
  /// **'권한 설정 필요'**
  String get needAccessPermission;

  /// No description provided for @accessPermissionDescription.
  ///
  /// In ko, this message translates to:
  /// **'갤러리 접근을 위해 설정에서 권한을 허용해 주세요.'**
  String get accessPermissionDescription;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @moveToSetting.
  ///
  /// In ko, this message translates to:
  /// **'설정으로 이동'**
  String get moveToSetting;

  /// No description provided for @confirmSetting.
  ///
  /// In ko, this message translates to:
  /// **'설정완료'**
  String get confirmSetting;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
