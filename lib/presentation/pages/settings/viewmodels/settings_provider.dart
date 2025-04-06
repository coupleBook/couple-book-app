import 'package:couple_book/data/local/datasources/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/datasources/last_login_local_data_source.dart';
import 'package:couple_book/data/repositories/couple_code_service.dart';
import 'package:couple_book/data/repositories/logout_service.dart';
import 'package:couple_book/presentation/pages/settings/models/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_view_model.dart';

final settingsViewModelProvider = StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  return SettingsViewModel(
    lastLoginLocalDataSource: LastLoginLocalDataSource(),
    coupleCodeLocalDataSource: CoupleCodeLocalDataSource.instance,
    logoutService: LogoutService(),
    coupleCodeService: CoupleCodeService(),
  );
});
