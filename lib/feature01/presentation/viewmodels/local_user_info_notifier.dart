import 'package:couple_book/feature01/data/local/local_user_info_storage.dart';
import 'package:couple_book/feature01/domain/models/local_user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalUserInfoNotifier extends StateNotifier<LocalUserInfo?> {
  final LocalUserInfoStorage _storage;

  LocalUserInfoNotifier(this._storage) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final loaded = await _storage.load();
    state = loaded;
  }

  Future<void> update(LocalUserInfo info) async {
    state = info;
    await _storage.save(info);
  }

  Future<void> clear() async {
    state = null;
    await _storage.clear();
  }
}
