import 'package:couple_book/api/session.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../env/environment.dart';
import '../main.dart';
import '../utils/security/auth_security.dart';
import 'auth_api/token_manager.dart';

final logger = Logger();
final tokenManager = TokenManager();

InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getAccessToken();
    logger.d('REQUEST[PATH]: ${options.uri.path}');
    logger.d('accessToken: $accessToken');

    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  },
  onError: (DioException e, ErrorInterceptorHandler handler) async {
    logger.d(
        'ON ERROR REQUEST[${e.requestOptions.method}]: ${e.requestOptions.path}');
    logger.d('ON ERROR RESPONSE: ${e.response}');
    logger.d('ON ERROR STATUS CODE: ${e.response?.statusCode}');
    logger.d('ON ERROR HEADER: ${e.response?.headers}');
    logger.d('ON ERROR DATA: ${e.response?.data}');

    // 에러 응답이 있고, INVALID_ACCESS_TOKEN 에러인지 확인
    if (e.response?.statusCode == 401 &&
        e.response?.data['error']?['code'] == 'ERROR_0006') {
      logger.d('INVALID_ACCESS_TOKEN detected. Attempting to refresh token.');

      try {
        final refreshToken = await getRefreshToken();

        if (refreshToken.isEmpty) {
          throw Exception("No refresh token available.");
        }

        // 리프레시 토큰으로 새 토큰 요청
        final dio = Dio(BaseOptions(
          baseUrl: Environment.restApiUrl,
          connectTimeout: const Duration(milliseconds: 60000),
          receiveTimeout: const Duration(milliseconds: 30000),
        ));
        final refreshResponse = await dio.post(
          '${Environment.restApiUrl}/api/v1/auth/refresh-token',
          // 리프레시 토큰 API 경로
          options: Options(headers: {'Refresh-Token': refreshToken}),
        );

        final newAccessToken = refreshResponse.headers['Authorization']?.first;
        final newRefreshToken = refreshResponse.headers['Refresh-Token']?.first;

        if (newAccessToken == null || newRefreshToken == null) {
          throw Exception("Failed to retrieve new tokens.");
        }

        // 새 토큰 저장
        await tokenManager.saveTokens(newAccessToken, newRefreshToken);

        // 요청 재시도
        final retryRequest =
            await _retryRequest(e.requestOptions, newAccessToken);
        return handler.resolve(retryRequest);
      } catch (error) {
        logger.e('Failed to refresh token: $error');

        GoRouter.of(CoupleBookApp.navKey.currentContext!).go('/Login');

        // 에러를 계속 처리
        return handler.reject(e);
      }
    }

    // 다른 에러는 그대로 전달
    return handler.next(e);
  },
);

/// ************************************************
/// 요청 재시도 함수
/// ************************************************
Future<Response> _retryRequest(
    RequestOptions requestOptions, String newAccessToken) async {
  final dio = Session().dio;
  return await dio.fetch(requestOptions);
}
