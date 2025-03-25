import 'dart:io';

import 'package:couple_book/api/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:couple_book/data/service/my_image_storage_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// 사용자 프로필 이미지 처리 로직을 담당하는 서비스
class UserProfileService {
  final Logger logger = Logger();

  final UserProfileApi _userProfileApi = UserProfileApi();
  final MyImageStorageService _myImageStorageService = MyImageStorageService();

  /// 사용자 프로필 이미지를 압축하고 서버에 업로드한 뒤 로컬에 저장
  Future<ProfileImageModificationResponseDto> updateUserProfileImage(File imageFile) async {
    try {
      final compressedImage = await _compressImage(imageFile);
      if (compressedImage == null) {
        logger.e("❌ 이미지 압축 실패");
        throw Exception("이미지 압축 실패");
      }

      final uploadFile = File(compressedImage.path);

      logger.i("✅ 원본 이미지 크기: ${imageFile.lengthSync()} bytes");
      logger.i("✅ 압축 이미지 크기: ${uploadFile.lengthSync()} bytes");

      final responseDto = await _userProfileApi.updateUserProfileImage(uploadFile);

      // 프로필 이미지 로컬 저장
      _myImageStorageService.saveImage(
        uploadFile,
        "myProfileImage",
        responseDto.profileImageVersion,
      );

      return responseDto;
    } catch (e, stack) {
      logger.e("❌ 프로필 이미지 업데이트 실패", error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// 이미지를 압축하여 임시 디렉토리에 저장
  Future<XFile?> _compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // 압축 품질 설정
      );

      return compressedFile;
    } catch (e, stack) {
      logger.e("❌ 이미지 압축 오류", error: e, stackTrace: stack);
      return null;
    }
  }
}
