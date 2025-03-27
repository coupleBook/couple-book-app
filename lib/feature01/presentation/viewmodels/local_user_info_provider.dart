import 'package:couple_book/feature01/data/local/local_user_info_storage.dart';
import 'package:couple_book/feature01/domain/models/local_user_info.dart';
import 'package:couple_book/feature01/presentation/viewmodels/local_user_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localUserInfoProvider = StateNotifierProvider<LocalUserInfoNotifier, LocalUserInfo?>((ref) {
  return LocalUserInfoNotifier(LocalUserInfoStorage());
});
