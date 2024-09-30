

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../dto/response_dto/create_couple_code_response_dto.dart';
import '../../dto/response_dto/find_user_info_response.dart';
import '../../env/environment.dart';
import '../session.dart';

class CoupleApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 커플 코드 생성 API
  /// ************************************************
  Future<CreateCoupleCodeResponseDto> createCoupleCode(String datingAnniversary) async {
    final Response<dynamic> response = await _dio.put(
      '${Environment.restApiUrl}/api/v1/couple/linkcode',
      data: {"datingAnniversary" : datingAnniversary}
    );

    return CreateCoupleCodeResponseDto.fromJson(response.data);
  }

  /// ************************************************
  /// 커플 코드로 유저 정보 조회 API
  /// ************************************************
  Future<FindUserInfoResponse> findUserInfoByCode(String coupleCode) async {
    final Response<dynamic> response = await _dio.get(
      '${Environment.restApiUrl}/api/v1/couple/linkcode',
      queryParameters: {"code" : coupleCode}
    );

    return FindUserInfoResponse.fromJson(response.data);
  }



}