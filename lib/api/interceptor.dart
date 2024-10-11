import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../utils/security/auth_security.dart';

/// 외부 통신 라이브러리 Dio 에 사용되는 interceptor 로
/// request 정보 및 response, erro handling, header 데이터 삽입 기능
/// TODO: request, response, error handling 추가 작업 필요
final logger = Logger();
InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getAccessToken();
    logger.d('REQUEST[PATH]: ${options.uri.path}');

    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  },
  onError: (DioError e, ErrorInterceptorHandler handler) async {
    logger.d(
        'ON ERROR REQUEST[${e.requestOptions.method}]: ${e.requestOptions.path}');
    logger.d('ON ERROR RESPONSE: ${e.response}');
    logger.d('ON ERROR STATUS CODE: ${e.response?.statusCode}');
    logger.d('ON ERROR HEADER: ${e.response?.headers}');

    handler.next(
      DioException(
        requestOptions: e.requestOptions,
        type: DioExceptionType.connectionError,
        message: 'Please check the network status.',
      ),
    );
  },
);
