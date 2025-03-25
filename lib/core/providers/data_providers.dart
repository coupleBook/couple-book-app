import 'package:couple_book/data/local/auth_local_data_source.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/data/service/login_service.dart';
import 'package:couple_book/data/service/my_profile_service.dart';
import 'package:couple_book/data/service/partner_profile_service.dart';
import 'package:couple_book/feature01/data/services/couple_code_service.dart';
import 'package:couple_book/feature01/data/services/user_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// **AuthLocalDataSource Provider**
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

/// **LocalUserLocalDataSource Provider**
final localUserLocalDataSourceProvider = Provider<LocalUserLocalDataSource>((ref) {
  return LocalUserLocalDataSource();
});

/// **MyProfileService Provider**
final myProfileServiceProvider = Provider<MyProfileService>((ref) {
  return MyProfileService();
});

/// **PartnerProfileService Provider**
final partnerProfileServiceProvider = Provider<PartnerProfileService>((ref) {
  return PartnerProfileService();
});

final loginServiceProvider = Provider<LoginService>((ref) {
  return LoginService();
});

final coupleCodeServiceProvider = Provider<CoupleCodeService>((ref) {
  return CoupleCodeService();
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});
