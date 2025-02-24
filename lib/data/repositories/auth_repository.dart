import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/data/local/last_login_local_data_source.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/data/local/partner_local_data_source.dart';
import 'package:couple_book/data/local/user_local_data_source.dart';
import 'package:intl/intl.dart';

import '../../core/utils/token_cleaner.dart';
import '../local/auth_local_data_source.dart';
import '../local/entities/auth_entity.dart';
import '../local/entities/last_login_entity.dart';
import '../local/entities/partner_entity.dart';
import '../local/user_profile_image_local_data_source.dart';
import '../remote/auth_api.dart';
import '../service/my_image_storage_service.dart';
import '../service/my_profile_service.dart';

class AuthRepository {
  final AuthApi authApi;
  final UserProfileApi userProfileApi;

  final AuthLocalDataSource localDataSource;
  final LastLoginLocalDataSource lastLoginLocalDataSource;

  final LocalUserLocalDataSource localUserLocalDataSource;

  final UserLocalDataSource userLocalDataSource;
  final PartnerLocalDataSource partnerLocalDataSource;

  final UserProfileImageLocalDataSource userProfileImageLocalDataSource =
      UserProfileImageLocalDataSource.instance;

  final MyImageStorageService myImageStorageService = MyImageStorageService();
  final myProfileService = MyProfileService();

  AuthRepository(
    this.authApi,
    this.userProfileApi,
    this.localDataSource,
    this.lastLoginLocalDataSource,
    this.localUserLocalDataSource,
    this.userLocalDataSource,
    this.partnerLocalDataSource,
  );

  Future<AuthEntity> signIn(LoginPlatform platform, String token) async {
    final response = await authApi.signIn(platform, token);

    final cleanAccessToken = TokenCleaner.cleanToken(response.accessToken);
    final cleanRefreshToken = TokenCleaner.cleanToken(response.refreshToken);

    final authEntity = AuthEntity(
        accessToken: cleanAccessToken, refreshToken: cleanRefreshToken);

    // 토큰 저장
    await localDataSource.saveAuthInfo(authEntity);
    // 마지막 로그인 정보 저장
    await lastLoginLocalDataSource.saveLastLogin(
        LastLoginEntity(loginId: response.me.id, platform: platform));

    // 본인 프로필 저장
    await myProfileService.saveProfile(response.me);

    // 커플 정보 저장
    if (response.coupleInfo != null) {
      // 기념일 저장
      await localUserLocalDataSource.saveLocalUser(LocalUserEntity(
          anniversary: DateFormat('yyyy-MM-dd')
              .format(response.coupleInfo!.datingAnniversary)));
      // 커플 정보 저장
      await partnerLocalDataSource.savePartner(
          PartnerEntity.fromMyInfoResponse(response.coupleInfo!.partner));
    }

    return authEntity;
  }
}
