import 'dart:convert';

import 'package:couple_book/data/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/couple_code_entity.dart';

class CoupleCodeLocalDataSource {
  static final CoupleCodeLocalDataSource instance = CoupleCodeLocalDataSource._internal();

  factory CoupleCodeLocalDataSource() => instance;

  CoupleCodeLocalDataSource._internal();

  static const _coupleCodeKey = 'COUPLE_CODE';

  Future<void> saveCoupleCode(CoupleCodeEntity code) async {
    await SecureStorageHelper.setItem(_coupleCodeKey, jsonEncode(code.toJson()));
  }

  Future<CoupleCodeEntity?> getCoupleCode() async {
    final data = await SecureStorageHelper.getItem(_coupleCodeKey);
    return data != null ? CoupleCodeEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearCoupleCode() async {
    await SecureStorageHelper.deleteItem(_coupleCodeKey);
  }
}
