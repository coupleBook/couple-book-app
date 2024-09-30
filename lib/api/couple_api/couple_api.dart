

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../dto/response_dto/create_couple_code_response_dto.dart';
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



}