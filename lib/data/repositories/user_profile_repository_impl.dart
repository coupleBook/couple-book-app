import 'dart:io';
import 'package:couple_book/core/utils/image/image_compressor.dart';
import 'package:couple_book/data/remote/datasources/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/data/remote/datasources/user_api/user_profile_api.dart';
import 'package:couple_book/data/repositories/my_image_storage_service.dart';
import 'package:couple_book/domain/repositories/user_profile_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApi _userProfileApi;
  final MyImageStorageService _myImageStorageService;

  UserProfileRepositoryImpl({
    required UserProfileApi userProfileApi,
    required MyImageStorageService myImageStorageService,
  })  : _userProfileApi = userProfileApi,
        _myImageStorageService = myImageStorageService;

  @override
  Future<ProfileImageModificationResponseDto> updateProfileImage(File imageFile) async {
    try {
      var compressedImage = await ImageCompressor.compressImage(imageFile);

      if (compressedImage == null) {
        logger.e("이미지 압축 실패");
        throw Exception("Failed to compress image");
      }

      var uploadImage = File(compressedImage.path);

      logger.i("원본 이미지 크기: ${imageFile.lengthSync()} bytes");
      logger.i("압축 이미지 크기: ${uploadImage.lengthSync()} bytes");

      final responseDto = await _userProfileApi.updateUserProfileImage(uploadImage);

      // TODO - 파일명 고정
      _myImageStorageService.saveImage(uploadImage, "myProfileImage", responseDto.profileImageVersion);

      return responseDto;
    } catch (e) {
      logger.e("Failed to update user profile image: $e");
      rethrow;
    }
  }
} 