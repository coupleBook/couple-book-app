import 'package:couple_book/data/local/datasources/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/entities/couple_code_entity.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_api.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/data/remote/datasources/couple_api/couple_linking_response_dto.dart';
import 'package:couple_book/data/remote/datasources/couple_api/create_couple_code_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'partner_profile_service.dart';

class CoupleCodeService {
  final logger = Logger();
  final coupleCodeLocalDataSource = CoupleCodeLocalDataSource.instance;
  final localUserLocalDataSource = LocalUserLocalDataSource.instance;
  final partnerProfileService = PartnerProfileService();
  final coupleApi = CoupleApi();

  // 커플 연동 코드 생성
  Future<CoupleCodeEntity?> generateCoupleLinkCode() async {
    try {
      final localUser = await localUserLocalDataSource.getAnniversary();
      if (localUser.isEmpty) {
        logger.e('LocalUser 정보가 없습니다.');
        return null;
      }

      final response = await coupleApi.createCoupleCode(localUser);
      final saved = saveEntity(response);

      logger.d('커플 연동 코드 생성 성공: $saved');
      return saved;
    } catch (e) {
      logger.e('커플 연동 코드 생성 실패: $e');
      return null;
    }
  }

  // 커플 연동 코드 조회
  Future<CoupleCodeCreatorInfoResponseDto?> getCoupleLinkCode(String code) async {
    try {
      final response = await coupleApi.findUserInfoByCode(code);
      logger.d('커플 연동 코드 조회 성공: $response');
      return response;
    } catch (e) {
      logger.e('커플 연동 코드 조회 실패: $e');
      return null;
    }
  }

  // 커플 연동 실행
  Future<CoupleLinkingResponseDto?> coupleLink(String code) async {
    try {
      final response = await coupleApi.linkCouple(code);

      final coupleInfo = response.coupleInfo!;
      final localUserEntity = LocalUserEntity(
        anniversary: coupleInfo.datingAnniversary.toIso8601String(),
      );

      await localUserLocalDataSource.saveLocalUser(localUserEntity);
      await partnerProfileService.saveProfile(coupleInfo.partner);
      await coupleCodeLocalDataSource.clearCoupleCode();

      logger.d('커플 연동 성공: $response');
      return response;
    } on DioException catch (e) {
      final message = e.response?.data['error']?['message'] ?? '알 수 없는 오류가 발생했습니다.';
      final code = e.response?.data['error']?['code'] ?? 'UNKNOWN_ERROR';

      logger.e('커플 연동 실패 (400 응답): $message');
      return CoupleLinkingResponseDto.failure(code: code, message: message);
    } catch (e) {
      logger.e('커플 연동 실패 (기타 오류): $e');
      return CoupleLinkingResponseDto.failure(
        code: 'EXCEPTION',
        message: '서버 오류가 발생했습니다.',
      );
    }
  }

  // 커플코드 저장
  CoupleCodeEntity saveEntity(CreateCoupleCodeResponseDto response) {
    final coupleCodeEntity = CoupleCodeEntity.fromDto(response);
    coupleCodeLocalDataSource.saveCoupleCode(coupleCodeEntity);
    return coupleCodeEntity;
  }
}
