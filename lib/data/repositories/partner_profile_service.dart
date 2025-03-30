import 'dart:io';

import 'package:couple_book/core/utils/image/profile_image_path.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/data/local/entities/partner_entity.dart';
import 'package:couple_book/data/local/entities/partner_profile_image_entity.dart';
import 'package:couple_book/data/remote/datasources/partner_api/partner_profile_api.dart';
import 'package:couple_book/data/remote/models/response/common/partner_info_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PartnerProfileService {
  final logger = Logger();

  final _localDataSource = PartnerLocalDataSource.instance;
  final _partnerProfileImageLocalDataSource = PartnerProfileImageLocalDataSource.instance;

  final _partnerProfileApi = PartnerProfileApi();

  Future<bool> saveProfile(PartnerInfoResponse response) async {
    final gender = response.gender;

    final partnerEntity = PartnerEntity(
      id: response.id,
      name: response.name,
      birthday: response.birthday,
      gender: gender != null ? Gender.fromServerValue(gender) : null,
      updatedAt: response.updatedAt,
    );

    _localDataSource.savePartner(partnerEntity);

    if (response.profileImageVersion <= 0) {
      if (response.profileImageVersion < 0) {
        logger.e("partnerProfileImageVersion is negative");
        return false;
      }
      return true;
    }

    final userProfileImageEntity = await _partnerProfileImageLocalDataSource.getPartnerProfileImage();

    if (userProfileImageEntity == null || userProfileImageEntity.version < response.profileImageVersion) {
      return await _fetchAndSaveProfileImage(response.profileImageVersion);
    }

    return true;
  }

  Future<bool> _fetchAndSaveProfileImage(int version) async {
    try {
      final profileImageResponseDto = await _partnerProfileApi.getPartnerProfileImage();
      final profileImageResponse = await http.get(Uri.parse(profileImageResponseDto.profileImageUrl));

      final path = await getProfileImagePath("partnerProfileImage");
      final file = File(path);
      await file.writeAsBytes(profileImageResponse.bodyBytes);

      await _partnerProfileImageLocalDataSource.savePartnerProfileImage(
        PartnerProfileImageEntity(
          filePath: path,
          version: profileImageResponseDto.profileImageVersion,
        ),
      );
      return true;
    } catch (e) {
      logger.e("Failed to fetch or save profile image: \$e");
      return false;
    }
  }
}
