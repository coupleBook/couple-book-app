import 'dart:io';

import 'package:couple_book/api/user_api/user_profile_api.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/data/local/partner_local_data_source.dart';
import 'package:couple_book/data/local/partner_profile_image_local_data_source.dart';
import 'package:couple_book/data/local/user_local_data_source.dart';
import 'package:couple_book/data/local/user_profile_image_local_data_source.dart';
import 'package:couple_book/data/service/my_profile_service.dart';
import 'package:couple_book/feature/auth/user_profile_service.dart';
import 'package:couple_book/feature01/viewmodels/dday_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DdayNotifier extends StateNotifier<DdayState> {
  final LocalUserLocalDataSource localUserLocalDataSource;
  final UserLocalDataSource userLocalDataSource;
  final UserProfileImageLocalDataSource userProfileImageLocalDataSource;
  final PartnerLocalDataSource partnerLocalDataSource;
  final PartnerProfileImageLocalDataSource partnerProfileImageLocalDataSource;
  final MyProfileService myProfileService;
  final UserProfileService userProfileService;
  final UserProfileApi userProfileApi;

  DdayNotifier(
    this.localUserLocalDataSource,
    this.userLocalDataSource,
    this.userProfileImageLocalDataSource,
    this.partnerLocalDataSource,
    this.partnerProfileImageLocalDataSource,
    this.myProfileService,
    this.userProfileService,
    this.userProfileApi,
  ) : super(DdayState(
          dday: '0',
          anniversaryDate: 'N/A',
          leftProfileName: "Honey",
          leftProfileBirthdate: "",
          rightProfileName: "Honey",
          rightProfileBirthdate: "",
        )) {
    _initializeState();
  }

  /// **🔹 초기 상태 로드**
  Future<void> _initializeState() async {
    try {
      await Future.wait([
        _loadDday(),
        _loadUserInfo(),
        _loadPartnerInfo(),
      ]);
    } catch (e) {
      logger.e('❌ 초기 데이터 로드 실패: $e');
    }
  }

  /// **🔹 D-Day 계산**
  Future<void> _loadDday() async {
    try {
      DateTime? anniversary = await localUserLocalDataSource.getAnniversaryToDatetime();
      if (anniversary != null) {
        final ddayValue = DateTime.now().difference(anniversary).inDays + 1;
        state = state.copyWith(
          dday: ddayValue.toString(),
          anniversaryDate: anniversary.toString().split(" ")[0],
        );
      }
    } catch (e) {
      logger.e('❌ D-Day 로드 실패: $e');
    }
  }

  /// **🔹 사용자 프로필 로드**
  Future<void> _loadUserInfo() async {
    try {
      final user = await userLocalDataSource.getUser();
      final userProfileImage = await userProfileImageLocalDataSource.getProfileImage();

      state = state.copyWith(
        leftProfileName: user?.name ?? "My",
        leftProfileBirthdate: user?.birthday ?? '',
        leftProfileGender: user?.gender,
        leftProfileImage: userProfileImage != null ? File(userProfileImage.filePath) : null,
      );
    } catch (e) {
      logger.e('❌ 사용자 프로필 로드 실패: $e');
    }
  }

  /// **🔹 파트너 프로필 로드**
  Future<void> _loadPartnerInfo() async {
    try {
      final partner = await partnerLocalDataSource.getPartner();
      final partnerProfileImage = await partnerProfileImageLocalDataSource.getPartnerProfileImage();

      state = state.copyWith(
        rightProfileName: partner?.name ?? "Honey",
        rightProfileBirthdate: partner?.birthday ?? '',
        rightProfileGender: partner?.gender,
        rightProfileImage: partnerProfileImage != null ? File(partnerProfileImage.filePath) : null,
      );
    } catch (e) {
      logger.e('❌ 파트너 프로필 로드 실패: $e');
    }
  }

  /// **🔹 왼쪽 프로필 업데이트 (API 연동)**
  Future<void> updateProfile(Map<String, dynamic> result) async {
    try {
      final updatedName = result['name'] as String;
      final updatedBirthdate = result['birthdate'] as String? ?? '';
      final updatedImage = result['image'] as File?;
      final updatedGender = result['gender'] as Gender?;

      // 변경 사항 확인 후 API 호출
      if (_validUpdateProfile(updatedName, updatedBirthdate, updatedGender)) {
        await applyUserProfileUpdate(updatedName, updatedBirthdate, updatedGender);
      }

      // 프로필 이미지 변경
      File? newProfileImage = state.leftProfileImage;
      if (updatedImage != null) {
        await userProfileService.updateUserProfileImage(updatedImage);
        newProfileImage = updatedImage;
      }

      // 상태 업데이트
      state = state.copyWith(
        leftProfileName: updatedName,
        leftProfileBirthdate: updatedBirthdate,
        leftProfileGender: updatedGender,
        leftProfileImage: newProfileImage,
      );
    } catch (e) {
      logger.e('❌ 프로필 업데이트 실패: $e');
    }
  }

  /// **🔹 사용자 정보 업데이트 API 호출**
  Future<void> applyUserProfileUpdate(String name, String? birthdate, Gender? gender) async {
    try {
      final updatedUserProfile = await userProfileApi.updateUserProfile(name, birthdate, gender);
      myProfileService.saveProfile(updatedUserProfile);
    } catch (e) {
      logger.e('❌ 사용자 정보 업데이트 실패: $e');
    }
  }

  /// **🔹 변경 사항 검증**
  bool _validUpdateProfile(String name, String? birthdate, Gender? gender) {
    return name != state.leftProfileName || birthdate != state.leftProfileBirthdate || gender != state.leftProfileGender;
  }
}

/// **📌 Provider 선언**
final ddayProvider = StateNotifierProvider<DdayNotifier, DdayState>((ref) {
  return DdayNotifier(
    LocalUserLocalDataSource.instance,
    UserLocalDataSource.instance,
    UserProfileImageLocalDataSource.instance,
    PartnerLocalDataSource.instance,
    PartnerProfileImageLocalDataSource.instance,
    MyProfileService(),
    UserProfileService(),
    UserProfileApi(),
  );
});
