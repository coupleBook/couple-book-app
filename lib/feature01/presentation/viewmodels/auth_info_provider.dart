import 'package:couple_book/feature01/data/local/auth_info_storage.dart';
import 'package:couple_book/feature01/domain/models/auth_info.dart';
import 'package:couple_book/feature01/presentation/viewmodels/auth_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authInfoStorageProvider = Provider((ref) => AuthInfoStorage());

final authInfoProvider = StateNotifierProvider<AuthInfoNotifier, AuthInfo?>((ref) {
  return AuthInfoNotifier(ref.watch(authInfoStorageProvider));
});
