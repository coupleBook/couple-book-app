import 'package:couple_book/data/remote/models/response/change_dating_date_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../session.dart';
import 'couple_code_creator_info_response.dart';
import 'couple_linking_response_dto.dart';
import 'create_couple_code_response_dto.dart';

class CoupleApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// 커플 코드 생성 API
  /// ************************************************
  Future<CreateCoupleCodeResponseDto> createCoupleCode(String datingAnniversary) async {
    final Response<dynamic> response = await _dio.put('/api/v1/couple/linkcode', data: {"datingAnniversary": datingAnniversary});

    return CreateCoupleCodeResponseDto.fromJson(response.data);
  }

  /// ************************************************
  /// 커플 코드로 유저 정보 조회 API
  /// ************************************************
  Future<CoupleCodeCreatorInfoResponseDto> findUserInfoByCode(String coupleCode) async {
    final Response<dynamic> response = await _dio.get('/api/v1/couple/linkcode', queryParameters: {"code": coupleCode});

    return CoupleCodeCreatorInfoResponseDto.fromJson(response.data);
  }

  /// ************************************************
  /// 커플 코드 연결 API
  /// TODO: DTO 를 ResponseDto 를 만들었는데 굳이 ResponseDto 가 필요한가? CoupleInfoDto와 공통 으로 묶을 순 없을까
  /// ************************************************
  Future<CoupleLinkingResponseDto> linkCouple(String coupleCode) async {
    final Response<dynamic> response = await _dio.post('/api/v1/couple/link', data: {"code": coupleCode});

    return CoupleLinkingResponseDto.fromJson(response.data);
  }

  /// ************************************************
  /// 사귄날 변경 API
  /// ************************************************
  Future<ChangeDatingDateResponseDto> changeDatingDate(String datingAnniversary) async {
    final Response<dynamic> response = await _dio.put('/api/v1/couple/anniversary/dating', data: {"datingAnniversary": datingAnniversary});

    return ChangeDatingDateResponseDto.fromJson(response.data);
  }
}
