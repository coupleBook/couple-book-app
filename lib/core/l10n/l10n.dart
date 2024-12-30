import 'package:couple_book/main.dart';

import 'app_localizations.dart';
import 'app_localizations_en.dart';

AppLocalizations get l10n {
  final context = CoupleBookApp.navKey.currentContext;
  final defaultLocalizations = AppLocalizationsEn();
  if (context == null) return defaultLocalizations;
  return AppLocalizations.of(context) ?? defaultLocalizations;
}
