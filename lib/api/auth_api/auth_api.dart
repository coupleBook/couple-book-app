import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../dto/response_dto/login_response_dto.dart';
import '../../core/constants/app_constants.dart';
import '../session.dart';

class AuthApi {
  final _dio = Session().dio;
  final logger = Logger();

  /// ************************************************
  /// SNS 로그인 API
  /// ************************************************
  Future<LoginResponseDto> signIn(String platform, String token) async {
    var dio = Dio(BaseOptions(
      baseUrl: AppConstants.restApiUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ));

    final Response<dynamic> response = await dio.post(
      '${AppConstants.restApiUrl}/api/v1/login/$platform',
      queryParameters: {'access_token': token},
    );
    final accessToken = response.headers["Authorization"]!.first;
    final refreshToken = response.headers["Refresh-Token"]!.first;

    logger.d('response :: $response');
    logger.d('accessToken :: $accessToken');

    return LoginResponseDto.fromJson(response.data, accessToken, refreshToken);
  }
}
