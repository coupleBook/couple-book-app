import 'dart:convert';

import 'package:couple_book/core/storage/secure_storage_helper.dart';
import 'package:couple_book/data/local/entities/partner_profile_image_entity.dart';

class PartnerProfileImageLocalDataSource {
  static final PartnerProfileImageLocalDataSource instance = PartnerProfileImageLocalDataSource._internal();

  factory PartnerProfileImageLocalDataSource() => instance;

  PartnerProfileImageLocalDataSource._internal();

  static const _partnerProfileImageKey = 'PARTNER_PROFILE_IMAGE';

  Future<void> savePartnerProfileImage(PartnerProfileImageEntity image) async {
    await SecureStorageHelper.setItem(_partnerProfileImageKey, jsonEncode(image.toJson()));
  }

  Future<PartnerProfileImageEntity?> getPartnerProfileImage() async {
    final data = await SecureStorageHelper.getItem(_partnerProfileImageKey);
    return data != null ? PartnerProfileImageEntity.fromJson(jsonDecode(data)) : null;
  }

  Future<void> clearPartnerProfileImage() async {
    await SecureStorageHelper.deleteItem(_partnerProfileImageKey);
  }
}
