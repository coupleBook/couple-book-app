import 'package:couple_book/main.dart';
import 'package:couple_book/core/l10n/app_localizations.dart';
import 'package:couple_book/core/l10n/app_localizations_en.dart';

AppLocalizations get l10n {
  final context = CoupleBookApp.navKey.currentContext;
  final defaultLocalizations = AppLocalizationsEn();
  if (context == null) return defaultLocalizations;
  return AppLocalizations.of(context) ?? defaultLocalizations;
}
