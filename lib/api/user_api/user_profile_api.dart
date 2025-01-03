import 'dart:io';

import 'package:couple_book/api/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/api/user_api/profile_modification_response_dto.dart';
import 'package:couple_book/dto/response_dto/user_profile_dto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/constants/app_constants.dart';
import '../session.dart';

class UserProfileApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 유저 프로필 조회 API
  /// ************************************************
  Future<UserProfileDto> getUserProfile() async {
    final Response<dynamic> response =
        await _dio.get('/api/v1/user/profile');

    return UserProfileDto.fromJson(response.data);
  }

  /// ************************************************
  /// 유저 프로필 변경 API
  /// ************************************************
  Future<ProfileModificationResponseDto> updateUserProfile(
    String name,
    String? birthday,
    String? gender,
  ) async {
    final Response<dynamic> response = await _dio.put(
        '/api/v1/user/profile',
        data: {"name": name, "birthday": birthday, "gender": gender});

    if (response.statusCode == 200) {
      return ProfileModificationResponseDto.fromJson(response.data);
    } else {
      throw Exception(
          "Failed to update user profile: ${response.statusCode}, ${response.data}");
    }
  }

  /// ************************************************
  /// 유저 프로필 이미지 변경 API
  /// ************************************************
  Future<ProfileImageModificationResponseDto> updateUserProfileImage(
      File imageFile) async {
    try {
      // FormData 생성
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // POST 요청
      final Response<dynamic> response = await _dio.post(
        '/api/v1/user/profile/image',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200) {
        return ProfileImageModificationResponseDto.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to update user profile image: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      logger.e("Error updating profile image: $e");
      rethrow;
    }
  }
}
