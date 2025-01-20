import 'dart:io';

import 'package:logger/logger.dart';

import '../../api/user_api/user_profile_api.dart';
import '../../core/utils/profile_image_path.dart';
import '../../core/utils/security/couple_security.dart';
import '../local/entities/user_profile_image_entity.dart';
import '../local/user_profile_image_local_data_source.dart';

class MyImageStorageService {
  final logger = Logger();

  final userProfileImageLocalDataSource =
      UserProfileImageLocalDataSource.instance;
  final userProfileApi = UserProfileApi();

  /// 이미지 저장
  Future<String> saveImage(File imageFile, String fileName, int version) async {
    try {
      // 파일 저장
      final imagePath = await getProfileImagePath(fileName);
      final savedImage = await imageFile.copy(imagePath);

      // SecureStorage에 메타데이터 저장
      userProfileImageLocalDataSource.saveProfileImage(
          UserProfileImageEntity(filePath: imagePath, version: version));

      return savedImage.path; // 저장된 이미지 경로 반환
    } catch (e) {
      throw Exception("Failed to save image: $e");
    }
  }

  /// 이미지 읽기
  Future<File?> getImage() async {
    try {
      final metadata = await userProfileImageLocalDataSource.getProfileImage();
      if (metadata == null) {
        return null;
      }

      final imagePath = await getProfileImagePath(metadata.filePath);
      final file = File(imagePath);

      if (await file.exists()) {
        return file;
      }

      return null; // 파일이 없으면 null 반환
    } catch (e) {
      logger.e("Failed to get image: $e");
      return null;
    }
  }

  /// 이미지 삭제
  Future<void> deleteImage() async {
    try {
      final metadata = await userProfileImageLocalDataSource.getProfileImage();
      if (metadata == null) {
        return;
      }

      final imagePath = await getProfileImagePath(metadata.filePath);
      final file = File(imagePath);

      if (await file.exists()) {
        await file.delete();
      }

      deleteProfileImage();
    } catch (e) {
      logger.e("Failed to delete image: $e");
      return;
    }
  }
}
