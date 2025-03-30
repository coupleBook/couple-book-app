import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_local_data_source.dart';
import 'package:couple_book/data/local/datasources/partner_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_local_data_source.dart';
import 'package:couple_book/data/local/datasources/user_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LogoutService {
  final logger = Logger();

  final authLocalDataSource = AuthLocalDataSource();
  final userLocalDataSource = UserLocalDataSource();
  final partnerLocalDataSource = PartnerLocalDataSource();
  final partnerProfileImageLocalDataSource = PartnerProfileImageLocalDataSource();
  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource();
  final localUserLocalDataSource = LocalUserLocalDataSource();

  Future<void> signOut(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        await _naverSignOut();
        break;
      case LoginPlatform.google:
        await _googleSignOut();
        break;
    }

    await _clearLocalToken();
  }

  Future<void> _naverSignOut() async {
    try {
      await FlutterNaverLogin.logOut();
      logger.d('네이버 로그아웃 성공');
    } catch (error) {
      logger.e('네이버 로그아웃 오류: $error');
      rethrow;
    }
  }

  Future<void> _googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      logger.d('구글 로그아웃 성공');
    } catch (error) {
      logger.e('구글 로그아웃 오류: $error');
      rethrow;
    }
  }

  Future<void> _clearLocalToken() async {
    try {
      await authLocalDataSource.clearAuthInfo();
      await userLocalDataSource.clearUser();
      await partnerLocalDataSource.clearPartner();
      await userProfileImageLocalDataSource.clearProfileImage();
      await partnerProfileImageLocalDataSource.clearPartnerProfileImage();
      await localUserLocalDataSource.clearLocalUser();

      logger.d('모든 토큰과 사용자 데이터가 삭제되었습니다.');
    } catch (e) {
      logger.e('logout error: $e');
    }
  }
}
