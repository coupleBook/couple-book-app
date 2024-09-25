

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../dto/response_dto/login_response_dto.dart';
import '../../env/environment.dart';
import '../session.dart';

class AuthApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// SNS 로그인 API
  /// TODO: DTO 만들어야하나?
  /// ************************************************
  Future<LoginResponseDto> signIn(String platform, String token) async {
    final Response<dynamic> response = await _dio.post(
      '${Environment.restApiUrl}/api/v1/login/$platform',
      queryParameters: {'access_token': token},
    );
    final accessToken = response.headers["Authorization"]!.first;

    logger.d('response :: $response');
    // logger.d('response.data:: ' + response.data);

    return LoginResponseDto.fromJson(response.data, accessToken);
  }
}