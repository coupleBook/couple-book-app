import 'package:couple_book/feature01/data/local/auth_info_storage.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/feature01/data/local/local_user_info_storage.dart';
import 'package:couple_book/data/local/partner_local_data_source.dart';
import 'package:couple_book/data/local/partner_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/user_local_data_source.dart';
import 'package:couple_book/data/local/user_profile_image_local_data_source.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class LogoutService {
  final logger = Logger();

  final authLocalDataSource = AuthInfoStorage();
  final userLocalDataSource = UserLocalDataSource();
  final partnerLocalDataSource = PartnerLocalDataSource();
  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource();
  final partnerProfileImageLocalDataSource = PartnerProfileImageLocalDataSource();
  final localUserLocalDataSource = LocalUserInfoStorage();

  Future<void> signOut(LoginPlatform platform) async {
    switch (platform) {
      case LoginPlatform.naver:
        await _naverSignOut();
        break;
      case LoginPlatform.google:
        await _googleSignOut();
        break;
    }
    await _clearLocalData();
  }

  Future<void> _naverSignOut() async {
    try {
      await FlutterNaverLogin.logOut();
      logger.d('네이버 로그아웃 성공');
    } catch (e) {
      logger.e('네이버 로그아웃 실패: $e');
      rethrow;
    }
  }

  Future<void> _googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      logger.d('구글 로그아웃 성공');
    } catch (e) {
      logger.e('구글 로그아웃 실패: $e');
      rethrow;
    }
  }

  Future<void> _clearLocalData() async {
    try {
      await authLocalDataSource.clear();
      await userLocalDataSource.clearUser();
      await partnerLocalDataSource.clearPartner();
      await userProfileImageLocalDataSource.clearProfileImage();
      await partnerProfileImageLocalDataSource.clearPartnerProfileImage();
      await localUserLocalDataSource.clear();
      logger.d('로컬 데이터 삭제 완료');
    } catch (e) {
      logger.e('로컬 데이터 삭제 실패: $e');
    }
  }
}
