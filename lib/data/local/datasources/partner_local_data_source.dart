import 'dart:convert';

import 'package:couple_book/data/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/partner_entity.dart';

class PartnerLocalDataSource {
  static final PartnerLocalDataSource instance =
      PartnerLocalDataSource._internal();

  factory PartnerLocalDataSource() => instance;

  PartnerLocalDataSource._internal();

  static const _partnerInfoKey = 'PARTNER_INFO';

  Future<void> savePartner(PartnerEntity partner) async {
    await SecureStorageHelper.setItem(
        _partnerInfoKey, jsonEncode(partner.toJson()));
  }

  Future<PartnerEntity?> getPartner() async {
    final data = await SecureStorageHelper.getItem(_partnerInfoKey);
    return data != null ? PartnerEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearPartner() async {
    await SecureStorageHelper.deleteItem(_partnerInfoKey);
  }
}
