import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/feature01/domain/models/login_result_model.dart';
import 'package:couple_book/feature01/repository/auth_repository.dart';
import 'package:couple_book/feature01/repository/auth_repository_provider.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  final Logger logger;

  LoginUseCase({required this.authRepository, required this.logger});

  Future<LoginResultModel> execute(LoginPlatform platform) async {
    try {
      final token = await _getTokenForPlatform(platform);
      final loginResultModel = await authRepository.signIn(platform, token);
      return loginResultModel;
    } catch (e, stack) {
      logger.e("LoginUseCase.signIn failed", error: e, stackTrace: stack);
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

    if (authHeaders == null || !authHeaders.containsKey('Authorization')) {
      throw Exception("구글 로그인 실패");
    }

    final googleToken = authHeaders['Authorization']?.replaceFirst('Bearer ', '');
    if (googleToken == null) throw Exception("구글 로그인 실패");

    return googleToken;
  }
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    authRepository: ref.watch(authRepositoryProvider),
    logger: Logger(),
  );
});
