import 'package:couple_book/api/auth/auth_api.dart';
import 'package:couple_book/utils/constants/login_platform.dart';
import 'package:couple_book/utils/security/auth_security.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LoginService {
  final logger = Logger();
  AuthApi authApi = AuthApi();

  /// ************************************************
  /// SNS 별 로그인 처리 함수 실행
  /// ************************************************
  Future<bool> signIn(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        return await _naverSignIn();
      case LoginPlatform.google:
        return await _googleSignIn(platform);
    }
  }

  /// ************************************************
  /// 네이버 로그인 처리 함수
  /// ************************************************
  Future<bool> _naverSignIn() async {
    try {
      await FlutterNaverLogin.logIn();
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      if (token.accessToken.isEmpty) {
        throw Exception("네이버 로그인 실패");
      }

      final response = await authApi.signIn('naver', token.accessToken);
      final accessToken = response.headers["Authorization"]!.first;

      // 'Bearer ' 제거
      String tokenWithoutBearer = accessToken.replaceFirst('Bearer ', '');
      // 모든 공백 제거
      String pureAccessToken = tokenWithoutBearer.replaceAll(' ', '');

      await setAccessToken(pureAccessToken);

      // 저장이 잘 됐는지 확인
      final savedToken = await getAccessToken();

      if (savedToken != pureAccessToken) {
        throw Exception("토큰 저장 실패");
      }

      return FlutterNaverLogin.isLoggedIn;
    } catch (error) {
      logger.e('네이버 로그인 오류: $error');
      rethrow;
    }
  }

  /// ************************************************
  /// 구글 로그인 처리 함수
  /// ************************************************
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
      final googleToken = authHeaders?['Authorization']?.replaceFirst('Bearer ', '');

      final response = await authApi.signIn('google', googleToken!);
      final accessToken = response.headers["Authorization"]!.first;

      // 'Bearer ' 제거
      String tokenWithoutBearer = accessToken.replaceFirst('Bearer ', '');
      // 모든 공백 제거
      String pureAccessToken = tokenWithoutBearer.replaceAll(' ', '');

      await setAccessToken(pureAccessToken);

      // 저장이 잘 됐는지 확인
      final savedToken = await getAccessToken();

      if (savedToken != pureAccessToken) {
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
