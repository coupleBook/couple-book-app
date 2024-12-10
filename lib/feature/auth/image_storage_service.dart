import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../utils/security/couple_security.dart';
import '../../utils/security/my_profile_image_dto.dart';

class ImageStorageService {
  /// 이미지 저장
  Future<String> saveImage(File imageFile, String fileName, int version) async {
    try {
      // 파일 저장
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/$fileName";
      final savedImage = await imageFile.copy(path);

      // SecureStorage에 메타데이터 저장
      setProfileImage(
          MyProfileImageDTO(fileName: fileName, profileImageVersion: version));

      return savedImage.path; // 저장된 이미지 경로 반환
    } catch (e) {
      throw Exception("Failed to save image: $e");
    }
  }

  /// 이미지 읽기
  Future<File?> getImage() async {
    try {
      final metadata = await getProfileImage();
      if (metadata == null) {
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/${metadata.fileName}";
      final file = File(path);

      if (await file.exists()) {
        return file;
      }

      return null; // 파일이 없으면 null 반환
    } catch (e) {
      throw Exception("Failed to get image: $e");
    }
  }

  /// 이미지 삭제
  Future<void> deleteImage() async {
    try {
      final metadata = await getProfileImage();
      if (metadata == null) {
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/${metadata.fileName}";
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }

      deleteProfileImage();
    } catch (e) {
      throw Exception("Failed to delete image: $e");
    }
  }
}
