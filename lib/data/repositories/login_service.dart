import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/last_login_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/remote/datasources/auth_api.dart';
import 'package:couple_book/data/repositories/auth_repository.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LoginService {
  final logger = Logger();
  final AuthApi authApi = AuthApi();
  final AuthRepository authRepository = AuthRepository(
    AuthApi(),
    AuthLocalDataSource(),
    LastLoginLocalDataSource(),
    LocalUserLocalDataSource(),
  );

  Future<bool> signIn(LoginPlatform platform) async {
    try {
      String token = await _getTokenForPlatform(platform);

      await authRepository.signIn(platform, token);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getTokenForPlatform(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        return await _naverLogin();
      case LoginPlatform.google:
        return await _googleLogin();
    }
  }

  Future<String> _naverLogin() async {
    await FlutterNaverLogin.logIn();
    final token = await FlutterNaverLogin.currentAccessToken;
    if (token.accessToken.isEmpty) throw Exception("네이버 로그인 실패");
    return token.accessToken;
  }

  Future<String> _googleLogin() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
        'https://www.googleapis.com/auth/user.birthday.read',
        'https://www.googleapis.com/auth/user.gender.read',
      ],
    );

    final result = await googleSignIn.signIn();
    final authHeaders = await result?.authHeaders;

    // 디버깅용 로그
    if (authHeaders != null) {
      for (var entry in authHeaders.entries) {
        logger.d('${entry.key}: ${entry.value}');
      }
    }

    final googleToken = authHeaders?['Authorization']?.replaceFirst('Bearer ', '');
    if (googleToken == null) throw Exception("구글 로그인 실패");

    return googleToken;
  }
}
