import 'package:couple_book/api/couple_api/couple_api.dart';
import 'package:couple_book/api/couple_api/couple_code_creator_info_response.dart';
import 'package:couple_book/api/couple_api/couple_linking_response_dto.dart';
import 'package:couple_book/data/local/couple_code_local_data_source.dart';
import 'package:couple_book/data/local/entities/couple_code_entity.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/data/service/partner_profile_service.dart';
import 'package:logger/logger.dart';

class CoupleCodeService {
  final logger = Logger();

  final coupleApi = CoupleApi();
  final coupleCodeLocalDataSource = CoupleCodeLocalDataSource.instance;
  final localUserLocalDataSource = LocalUserLocalDataSource.instance;
  final partnerProfileService = PartnerProfileService();

  Future<CoupleCodeEntity?> generateCoupleLinkCode() async {
    try {
      final localUser = await localUserLocalDataSource.getAnniversary();
      if (localUser.isEmpty) {
        logger.e('LocalUser 정보 없음');
        return null;
      }

      final dto = await coupleApi.createCoupleCode(localUser);
      final entity = CoupleCodeEntity.fromDto(dto);
      coupleCodeLocalDataSource.saveCoupleCode(entity);

      logger.d('커플 코드 생성 성공: ${entity.code}');
      return entity;
    } catch (e) {
      logger.e('커플 코드 생성 실패: $e');
      return null;
    }
  }

  Future<CoupleCodeCreatorInfoResponseDto?> getCoupleLinkCode(String code) async {
    try {
      return await coupleApi.findUserInfoByCode(code);
    } catch (e) {
      logger.e('코드 조회 실패: $e');
      return null;
    }
  }

  Future<CoupleLinkingResponseDto?> coupleLink(String code) async {
    try {
      final response = await coupleApi.linkCouple(code);
      final coupleInfo = response.coupleInfo;
      final user = LocalUserEntity(anniversary: coupleInfo.datingAnniversary.toIso8601String());
      await localUserLocalDataSource.saveLocalUser(user);
      await partnerProfileService.saveProfile(coupleInfo.partner);
      await coupleCodeLocalDataSource.clearCoupleCode();
      return response;
    } catch (e) {
      logger.e('커플 연동 실패: $e');
      return null;
    }
  }
}
