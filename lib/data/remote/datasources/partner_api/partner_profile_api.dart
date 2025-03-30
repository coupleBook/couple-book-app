import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../session.dart';
import '../user_api/profile_image_response_dto.dart';

class PartnerProfileApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 파트너 프로필 이미지 조회 API
  /// ************************************************
  Future<ProfileImageResponseDto> getPartnerProfileImage() async {
    final Response<dynamic> response =
        await _dio.get('/api/v1/partner/profile/image');

    if (response.statusCode == 200) {
      return ProfileImageResponseDto.fromJson(response.data);
    } else {
      throw Exception(
          "Failed to get user profile image: ${response.statusCode}, ${response.data}");
    }
  }
}
