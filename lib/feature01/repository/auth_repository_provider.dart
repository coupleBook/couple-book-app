import 'package:couple_book/data/local/last_login_local_data_source.dart';
import 'package:couple_book/feature01/data/local/local_user_info_storage.dart';
import 'package:couple_book/data/remote/auth_api.dart';
import 'package:couple_book/data/service/my_profile_service.dart';
import 'package:couple_book/data/service/partner_profile_service.dart';
import 'package:couple_book/feature01/data/local/auth_info_storage.dart';
import 'package:couple_book/feature01/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authApi: AuthApi(),
    authLocal: AuthInfoStorage(),
    lastLoginLocal: LastLoginLocalDataSource(),
    localUserLocal: LocalUserInfoStorage(),
    myProfileService: MyProfileService(),
    partnerProfileService: PartnerProfileService(),
  );
});
