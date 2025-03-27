import 'package:couple_book/feature01/data/local/local_user_info_storage.dart';
import 'package:couple_book/data/service/my_profile_service.dart';
import 'package:couple_book/data/service/partner_profile_service.dart';
import 'package:couple_book/feature01/data/local/auth_info_storage.dart';
import 'package:couple_book/feature01/data/services/couple_code_service.dart';
import 'package:couple_book/feature01/data/services/user_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// **AuthLocalDataSource Provider**
final authLocalDataSourceProvider = Provider<AuthInfoStorage>((ref) {
  return AuthInfoStorage();
});

/// **LocalUserLocalDataSource Provider**
final localUserLocalDataSourceProvider = Provider<LocalUserInfoStorage>((ref) {
  return LocalUserInfoStorage();
});

/// **MyProfileService Provider**
final myProfileServiceProvider = Provider<MyProfileService>((ref) {
  return MyProfileService();
});

/// **PartnerProfileService Provider**
final partnerProfileServiceProvider = Provider<PartnerProfileService>((ref) {
  return PartnerProfileService();
});

final coupleCodeServiceProvider = Provider<CoupleCodeService>((ref) {
  return CoupleCodeService();
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});
