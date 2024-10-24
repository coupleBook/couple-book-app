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
  /// ************************************************
  Future<LoginResponseDto> signIn(String platform, String token) async {
    var dio = Dio(BaseOptions(
      baseUrl: Environment.restApiUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ));

    final Response<dynamic> response = await dio.post(
      '${Environment.restApiUrl}/api/v1/login/$platform',
      queryParameters: {'access_token': token},
    );
    final accessToken = response.headers["Authorization"]!.first;

    logger.d('response :: $response');
    logger.d('accessToken :: $accessToken');

    return LoginResponseDto.fromJson(response.data, accessToken);
  }

  /// ************************************************
  /// SNS 로그인 API
  /// ************************************************
  Future<void> logout() async {
    await _dio.delete('${Environment.restApiUrl}/api/v1/logout');
  }
}
