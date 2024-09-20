import 'package:couple_book/env/environment.dart';
import 'package:couple_book/pages/login/login_platform.dart';
import 'package:dio/dio.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LoginService {
  final logger = Logger();
  // TODO 공통 상수 분리.
  late final Dio _dio;

  LoginService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${Environment.restApiUrl}/api/v1/login',
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ));
  }

  Future<bool> signIn(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        return await _naverSignIn();
      case LoginPlatform.google:
        return await _googleSignIn(platform);
    }
  }

  Future<bool> _naverSignIn() async {
    try {
      await FlutterNaverLogin.logIn();
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      logger.d('token: ${token.accessToken}');
      if (token.accessToken.isEmpty) {
        throw Exception("네이버 로그인 실패");
      }

      final response = await _dio.get(
        "/naver",
        queryParameters: {"access_token": token.accessToken},
      );

      final accessToken = response.headers["Authorization"]!.first;
      logger.d("naverAccessToken : $accessToken");

      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: "accessToken", value: accessToken);

      return FlutterNaverLogin.isLoggedIn;
    } catch (error) {
      logger.e('네이버 로그인 오류: $error');
      rethrow;
    }
  }

  Future<bool> _googleSignIn(LoginPlatform platform) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/user.birthday.read',
          'https://www.googleapis.com/auth/user.gender.read',
        ],
      );
      final result = await googleSignIn.signIn();
      final authHeaders = await result?.authHeaders;
      if (authHeaders != null) {
        for (var entry in authHeaders.entries) {
          logger.d('${entry.key}: ${entry.value}');
        }
      }
      final googleToken =
          authHeaders?['Authorization']?.replaceFirst('Bearer ', '');
      logger.d('google accessToken: $googleToken');

      final response = await _dio.get(
        "/google",
        queryParameters: {"access_token": googleToken},
      );

      final accessToken = response.headers["Authorization"]!.first;
      logger.d("googleAccessToken : $accessToken");

      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: "accessToken", value: accessToken);

      // 저장이 잘 됐는지 확인
      final savedToken = await secureStorage.read(key: "accessToken");
      if (savedToken != accessToken) {
        throw Exception("토큰 저장 실패");
      }
      logger.d("토큰이 성공적으로 저장되었습니다.");

      return googleSignIn.isSignedIn();
    } catch (error) {
      logger.e('구글 로그인 오류: $error');
      rethrow;
    }
  }
}
