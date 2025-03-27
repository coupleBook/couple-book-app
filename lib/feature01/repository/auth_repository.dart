import 'package:couple_book/core/utils/token_cleaner.dart';
import 'package:couple_book/data/local/entities/enums/login_platform.dart';
import 'package:couple_book/data/local/entities/last_login_entity.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/data/local/last_login_local_data_source.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/data/remote/auth_api.dart';
import 'package:couple_book/data/service/my_profile_service.dart';
import 'package:couple_book/data/service/partner_profile_service.dart';
import 'package:couple_book/feature01/data/local/auth_local_data_source.dart';
import 'package:couple_book/feature01/domain/models/auth_model.dart';
import 'package:couple_book/feature01/domain/models/login_result_model.dart';
import 'package:intl/intl.dart';

class AuthRepository {
  final AuthApi _authApi;
  final AuthLocalDataSource _authLocal;
  final LastLoginLocalDataSource _lastLoginLocal;
  final LocalUserLocalDataSource _localUserLocal;
  final MyProfileService _myProfileService;
  final PartnerProfileService _partnerProfileService;

  AuthRepository({
    required AuthApi authApi,
    required AuthLocalDataSource authLocal,
    required LastLoginLocalDataSource lastLoginLocal,
    required LocalUserLocalDataSource localUserLocal,
    required MyProfileService myProfileService,
    required PartnerProfileService partnerProfileService,
  })  : _authApi = authApi,
        _authLocal = authLocal,
        _lastLoginLocal = lastLoginLocal,
        _localUserLocal = localUserLocal,
        _myProfileService = myProfileService,
        _partnerProfileService = partnerProfileService;

  Future<LoginResultModel> signIn(LoginPlatform platform, String token) async {
    final response = await _authApi.signIn(platform, token);

    final access = TokenCleaner.cleanToken(response.accessToken);
    final refresh = TokenCleaner.cleanToken(response.refreshToken);
    final authModel = AuthModel(accessToken: access, refreshToken: refresh);

    await _authLocal.saveAuthInfo(authModel.toEntity());
    await _lastLoginLocal.saveLastLogin(LastLoginEntity(loginId: response.me.id, platform: platform));
    await _myProfileService.saveProfile(response.me);

    if (response.coupleInfo != null) {
      final localUserEntity = LocalUserEntity(anniversary: DateFormat('yyyy-MM-dd').format(response.coupleInfo!.datingAnniversary));

      await _localUserLocal.saveLocalUser(localUserEntity);
      await _partnerProfileService.saveProfile(response.coupleInfo!.partner);
    }

    return LoginResultModel(
      auth: authModel,
      user: response.me,
      coupleInfo: response.coupleInfo,
    );
  }
}
