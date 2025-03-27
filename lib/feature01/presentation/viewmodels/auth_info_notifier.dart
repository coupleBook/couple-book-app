import 'package:couple_book/feature01/data/local/auth_info_storage.dart';
import 'package:couple_book/feature01/domain/models/auth_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInfoNotifier extends StateNotifier<AuthInfo?> {
  final AuthInfoStorage _storage;

  AuthInfoNotifier(this._storage) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final loaded = await _storage.load();
    state = loaded;
  }

  Future<void> update(AuthInfo info) async {
    state = info;
    await _storage.save(info);
  }

  Future<void> clear() async {
    state = null;
    await _storage.clear();
  }

  bool get hasToken => state?.accessToken.isNotEmpty == true;
}
