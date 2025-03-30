import 'dart:io';

import 'package:couple_book/api/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:couple_book/data/repositories/my_image_storage_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileService {
  final userProfileApi = UserProfileApi();
  final myImageStorageService = MyImageStorageService();
  final logger = Logger();

  Future<ProfileImageModificationResponseDto> updateUserProfileImage(
      File imageFile) async {
    try {
      var compressedImage = await _compressImage(imageFile);

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
      myImageStorageService.saveImage(
          uploadImage, "myProfileImage", responseDto.profileImageVersion);

      return responseDto;
    } catch (e) {
      logger.e("Failed to update user profile image: $e");
      rethrow;
    }
  }

  Future<XFile?> _compressImage(File file) async {
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
