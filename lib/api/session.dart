// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';

import '../env/environment.dart';
import 'interceptor.dart';

/// 앱 전반적으로 사용하는 데이터들을 관리, dio 의 interceptor 주입, 싱글톤으로 관리
class Session {
  static final Session _instance = Session._internal();

  factory Session() => _instance;

  static Dio _dio = Dio();

  Dio get dio => _dio;

  Session._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: Environment.restApiUrl,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
    );

    _dio = Dio(options);
    _dio.interceptors.add(interceptorsWrapper);
  }
}
