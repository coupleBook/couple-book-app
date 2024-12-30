import 'dart:io';

import 'package:couple_book/api/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/response/common/my_info_response.dart';
import '../../utils/security/couple_security.dart';
import 'image_storage_service.dart';

class UserProfileService {
  final userProfileApi = UserProfileApi();
  final imageStorageService = ImageStorageService();
  final logger = Logger();

  Future<void> updateUserProfile(
    String name,
    String? birthday,
    String? gender,
  ) async {
    try {
      // 현재 로컬에 저장된 사용자 정보 가져오기
      final currentProfile = await getMyInfo();

      if (currentProfile == null) {
        logger.e("No current profile found in local storage.");
        throw Exception("Cannot update profile: No current profile found.");
      }

      var responseDto =
          await userProfileApi.updateUserProfile(name, birthday, gender);

      // 서버에서 받은 DTO 데이터를 MyInfoDto로 변환
      final updatedProfile = MyInfoResponse(
        id: responseDto.id,
        name: responseDto.name,
        birthday: responseDto.birthDate,
        gender: responseDto.gender,
        profileImageVersion: currentProfile.profileImageVersion,
        provider: currentProfile.provider,
        updatedAt: responseDto.updatedAt.toIso8601String(),
      );

      await setMyInfo(updatedProfile);
      logger.d("User profile successfully updated and synced.");
    } catch (e) {
      logger.e("Failed to update user profile: $e");
      rethrow;
    }
  }

  Future<ProfileImageModificationResponseDto> updateUserProfileImage(
      File imageFile) async {
    try {
      var compressedImage = await compressImage(imageFile);

      if (compressedImage == null) {
        logger.e("이미지 압축 실패");
        throw Exception("Failed to compress image");
      }

      var uploadImage = File(compressedImage.path);

      logger.i("원본 이미지 크기: ${imageFile.lengthSync()} bytes");
      logger.i("압축 이미지 크기: ${uploadImage.lengthSync()} bytes");

      final responseDto =
          await userProfileApi.updateUserProfileImage(uploadImage);

      // TODO - 파일명 고정
      imageStorageService.saveImage(
          uploadImage, "myProfileImage", responseDto.profileImageVersion);

      return responseDto;
    } catch (e) {
      logger.e("Failed to update user profile image: $e");
      rethrow;
    }
  }

  Future<XFile?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // 압축 품질 (0~100, 낮을수록 압축률 높음)
      );

      return compressedFile;
    } catch (e) {
      logger.e("이미지 압축 중 오류 발생: $e");
      return null;
    }
  }
}
