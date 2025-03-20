import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/auth_local_data_source.dart';
import '../../data/local/local_user_local_data_source.dart';
import '../../data/service/my_profile_service.dart';
import '../../data/service/partner_profile_service.dart';

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
