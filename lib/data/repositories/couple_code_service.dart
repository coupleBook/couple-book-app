import 'package:couple_book/data/local/datasources/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/entities/couple_code_entity.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_api.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_linking_response_dto.dart';
import 'package:couple_book/data/remote/datasources/couple_api/create_couple_code_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'partner_profile_service.dart';

class CoupleCodeService {
  final logger = Logger();
  final BuildContext context;

  CoupleCodeService(this.context);

  // 커플코드 상태 저장소
  final coupleCodeLocalDataSource = CoupleCodeLocalDataSource.instance;

  // 커플코드 연동 후 상태 저장소
  final localUserLocalDataSource = LocalUserLocalDataSource.instance;

  final partnerProfileService = PartnerProfileService();

  final coupleApi = CoupleApi();

  // 커플코드 저장
  Future<CoupleCodeEntity?> generateCoupleLinkCode() async {
    try {
      var localUser = await localUserLocalDataSource.getAnniversary();
      if (localUser == '') {
        logger.e('LocalUser 정보가 없습니다.');
        _showSnackBar('LocalUser 정보가 없습니다.');
        return Future.value(null);
      }

      final response = await coupleApi.createCoupleCode(localUser).then((value) => saveEntity(value));

      logger.d('커플 연동 코드 생성 성공: $response');
      _showSnackBar('커플 연동 코드가 생성되었습니다.');

      return response;
    } catch (e) {
      logger.e('커플 연동 코드 생성 실패: $e');
      _showSnackBar('커플 연동 코드 생성 실패: $e');
      return Future.value(null);
    }
  }

  // 커플 연동 코드 조회 (입력된 코드 사용)
  Future<CoupleCodeCreatorInfoResponseDto?> getCoupleLinkCode(String code) async {
    try {
      final response = await coupleApi.findUserInfoByCode(code);
      logger.d('커플 연동 코드 조회 성공: $response');

      return response;
    } catch (e) {
      logger.e('커플 연동 코드 조회 실패: $e');
      _showSnackBar('커플 연동 코드 조회 실패: $e');
    }
    return null;
  }

  // 커플 연동하기 (입력된 코드 사용)
  Future<CoupleLinkingResponseDto?> coupleLink(String code) async {
    try {
      final response = await coupleApi.linkCouple(code);
      final coupleInfo = response.coupleInfo;
      final localUserEntity = LocalUserEntity(anniversary: coupleInfo.datingAnniversary.toIso8601String());

      localUserLocalDataSource.saveLocalUser(localUserEntity);

      partnerProfileService.saveProfile(coupleInfo.partner);
      coupleCodeLocalDataSource.clearCoupleCode();

      logger.d('커플 연동 성공: $response');
      _showSnackBar('커플 연동에 성공했습니다.');
      return response;
    } catch (e) {
      logger.e('커플 연동 실패: $e');
      _showSnackBar('커플 연동 실패: $e');
      return Future.value(null);
    }
  }

  CoupleCodeEntity saveEntity(CreateCoupleCodeResponseDto response) {
    final coupleCodeEntity = CoupleCodeEntity.fromDto(response);
    coupleCodeLocalDataSource.saveCoupleCode(coupleCodeEntity);
    return coupleCodeEntity;
  }

  // SnackBar 표시 함수
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
