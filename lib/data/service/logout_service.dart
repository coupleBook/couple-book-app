import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../../feature01/data/local/auth_info_storage.dart';
import '../local/entities/enums/login_platform.dart';
import '../../feature01/data/local/local_user_info_storage.dart';
import '../local/partner_local_data_source.dart';
import '../local/partner_profile_image_local_data_source.dart';
import '../local/user_local_data_source.dart';
import '../local/user_profile_image_local_data_source.dart';

class LogoutService {
  final logger = Logger();

  final authLocalDataSource = AuthInfoStorage();
  final userLocalDataSource = UserLocalDataSource();
  final partnerLocalDataSource = PartnerLocalDataSource();
  final partnerProfileImageLocalDataSource =
      PartnerProfileImageLocalDataSource();
  final userProfileImageLocalDataSource = UserProfileImageLocalDataSource();
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
      await authLocalDataSource.clear();
      await userLocalDataSource.clearUser();
      await partnerLocalDataSource.clearPartner();
      await userProfileImageLocalDataSource.clearProfileImage();
      await partnerProfileImageLocalDataSource.clearPartnerProfileImage();

      /// 여러 계정을 쓸 걸 생각하고 추가했던 건데, 하나의 계정만 쓴다면 기념일을 초기화할 필요가 없음. 추후에 다시 확인.
      // await localUserLocalDataSource.clearLocalUser();

      logger.d('모든 토큰과 사용자 데이터가 삭제되었습니다.');
    } catch (e) {
      logger.e('logout error: $e');
    }
  }
}
