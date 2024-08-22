import 'package:COUPLE_BOOK/l10n/app_localizations.dart';
import 'package:COUPLE_BOOK/l10n/app_localizations_en.dart';
import 'package:COUPLE_BOOK/main.dart';

AppLocalizations get l10n {
  final context = CoupleBookApp.navKey.currentContext;
  final defaultLocalizations = AppLocalizationsEn();
  if (context == null) return defaultLocalizations;
  return AppLocalizations.of(context) ?? defaultLocalizations;
}
