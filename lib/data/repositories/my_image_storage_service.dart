import 'dart:io';

import 'package:couple_book/core/utils/image/profile_image_path.dart';
import 'package:couple_book/data/local/datasources/user_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/entities/user_profile_image_entity.dart';
import 'package:couple_book/data/remote/datasources/user_api/user_profile_api.dart';
import 'package:logger/logger.dart';

class MyImageStorageService {
  final logger = Logger();

  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource.instance;
  final userProfileApi = UserProfileApi();

  /// 이미지 저장
  Future<String> saveImage(File imageFile, String fileName, int version) async {
    try {
      // 파일 저장
      final imagePath = await getProfileImagePath(fileName);
      final savedImage = await imageFile.copy(imagePath);

      // SecureStorage에 메타데이터 저장
      userProfileImageLocalDataSource.saveProfileImage(UserProfileImageEntity(filePath: imagePath, version: version));

      return savedImage.path; // 저장된 이미지 경로 반환
    } catch (e) {
      throw Exception("Failed to save image: $e");
    }
  }
}
