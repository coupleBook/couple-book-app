

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../dto/response_dto/change_dating_date_response_dto.dart';
import '../../dto/response_dto/couple_info_response_dto.dart';
import '../../dto/response_dto/create_couple_code_response_dto.dart';
import '../../dto/response_dto/couple_code_creator_info_response.dart';
import '../../core/constants/app_constants.dart';
import '../session.dart';

class CoupleApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 커플 코드 생성 API
  /// ************************************************
  Future<CreateCoupleCodeResponseDto> createCoupleCode(String datingAnniversary) async {
    final Response<dynamic> response = await _dio.put(
      '${AppConstants.restApiUrl}/api/v1/couple/linkcode',
      data: {"datingAnniversary" : datingAnniversary}
    );

    return CreateCoupleCodeResponseDto.fromJson(response.data);
  }

  /// ************************************************
  /// 커플 코드로 유저 정보 조회 API
  /// ************************************************
  Future<CoupleCodeCreatorInfoResponse> findUserInfoByCode(String coupleCode) async {
    final Response<dynamic> response = await _dio.get(
      '${AppConstants.restApiUrl}/api/v1/couple/linkcode',
      queryParameters: {"code" : coupleCode}
    );

    return CoupleCodeCreatorInfoResponse.fromJson(response.data);
  }

  /// ************************************************
  /// 커플 코드 연결 API
  /// TODO: DTO 를 ResponseDto 를 만들었는데 굳이 ResponseDto 가 필요한가? CoupleInfoDto와 공통 으로 묶을 순 없을까
  /// ************************************************
  Future<CoupleInfoResponseModel> linkCouple(String coupleCode) async {
    final Response<dynamic> response = await _dio.post(
      '${AppConstants.restApiUrl}/api/v1/couple/link',
      data: {"code" : coupleCode}
    );

    return CoupleInfoResponseModel.fromJson(response.data);
  }

  /// ************************************************
  /// 사귄날 변경 API
  /// ************************************************
  Future<ChangeDatingDateResponseDto> changeDatingDate(String datingAnniversary) async {
    final Response<dynamic> response = await _dio.put(
      '${AppConstants.restApiUrl}/api/v1/couple/anniversary/dating',
      data: {"datingAnniversary" : datingAnniversary}
    );

    return ChangeDatingDateResponseDto.fromJson(response.data);
  }
}