import 'package:couple_book/dto/response_dto/user_profile_dto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../env/environment.dart';
import '../session.dart';

class UserProfileApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 유저 프로필 조회 API
  /// ************************************************
  Future<UserProfileDto> getUserProfile() async {
    final Response<dynamic> response =
        await _dio.get('${Environment.restApiUrl}/api/v1/user/profile');

    return UserProfileDto.fromJson(response.data);
  }
}
