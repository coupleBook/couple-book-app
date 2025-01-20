import 'dart:io';

import 'package:couple_book/api/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/api/user_api/profile_image_response_dto.dart';
import 'package:couple_book/api/user_api/user_profile_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../data/local/entities/enums/gender_enum.dart';
import '../../data/models/response/common/my_info_response.dart';
import '../session.dart';

class UserProfileApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 유저 프로필 조회 API
  /// ************************************************
  Future<UserProfileResponseDto> getUserProfile() async {
    final Response<dynamic> response = await _dio.get('/api/v1/user/profile');

    return UserProfileResponseDto.fromJson(response.data);
  }

  Future<ProfileImageResponseDto> getUserProfileImage() async {
    final Response<dynamic> response =
        await _dio.get('/api/v1/user/profile/image');

    if (response.statusCode == 200) {
      return ProfileImageResponseDto.fromJson(response.data);
    } else {
      throw Exception(
          "Failed to get user profile image: ${response.statusCode}, ${response.data}");
    }
  }

  /// ************************************************
  /// 유저 프로필 변경 API
  /// ************************************************
  Future<MyInfoResponse> updateUserProfile(
    String name,
    String? birthday,
    Gender? gender,
  ) async {
    final Response<dynamic> response = await _dio.put(
      '/api/v1/user/profile',
      data: {
        "name": name,
        "birthday": birthday,
        "gender": gender?.toServerValue(),
      },
    );

    if (response.statusCode == 200) {
      return MyInfoResponse.fromJson(response.data['data']);
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
