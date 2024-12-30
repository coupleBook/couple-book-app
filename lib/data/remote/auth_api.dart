import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/constants/app_constants.dart';
import '../models/response/login_response_model.dart';

class AuthApi {
  static final AuthApi instance = AuthApi._internal();

  factory AuthApi() => instance;

  AuthApi._internal();

  final logger = Logger();

  final _dio = Dio(BaseOptions(
    baseUrl: AppConstants.restApiUrl,
    connectTimeout: const Duration(milliseconds: 60000),
    receiveTimeout: const Duration(milliseconds: 30000),
  ));

  /// ************************************************
  /// SNS 로그인 API
  /// ************************************************
  Future<LoginResponseModel> signIn(
    LoginPlatform platform,
    String token,
  ) async {
    final response = await _dio.post(
      '/api/v1/login/${platform.name}',
      queryParameters: {'access_token': token},
    );

    final accessToken = response.headers["Authorization"]!.first;
    final refreshToken = response.headers["Refresh-Token"]!.first;

    logger.d('response :: $response');
    logger.d('accessToken :: $accessToken');

    return LoginResponseModel.fromJson(
      response.data,
      accessToken,
      refreshToken,
    );
  }
}
