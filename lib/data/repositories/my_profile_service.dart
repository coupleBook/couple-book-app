import 'dart:io';

import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:couple_book/core/utils/image/profile_image_path.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/entities/user_entity.dart';
import 'package:couple_book/data/local/entities/user_profile_image_entity.dart';
import 'package:couple_book/data/remote/models/response/common/my_info_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MyProfileService {
  final logger = Logger();

  final userLocalDataSource = UserLocalDataSource.instance;
  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource.instance;

  final userProfileApi = UserProfileApi();

  Future<bool> saveProfile(MyInfoResponse response) async {
    await userLocalDataSource.saveUser(UserEntity.fromMyInfoResponse(response));

    if (response.profileImageVersion <= 0) {
      if (response.profileImageVersion < 0) {
        logger.e("profileImageVersion is negative");
        return false;
      }
      return true;
    }

    final userProfileImageEntity = await userProfileImageLocalDataSource.getProfileImage();
    if (userProfileImageEntity == null || userProfileImageEntity.version < response.profileImageVersion) {
      return await _fetchAndSaveProfileImage(response.profileImageVersion);
    }

    return true;
  }

  Future<bool> _fetchAndSaveProfileImage(int version) async {
    try {
      final profileImageResponseDto = await userProfileApi.getUserProfileImage();
      final profileImageResponse = await http.get(Uri.parse(profileImageResponseDto.profileImageUrl));

      final path = await getProfileImagePath("myProfileImage");
      final file = File(path);
      await file.writeAsBytes(profileImageResponse.bodyBytes);

      await userProfileImageLocalDataSource.saveProfileImage(
        UserProfileImageEntity(
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
