import 'package:couple_book/data/local/partner_local_data_source.dart';

import '../local/entities/enums/gender_enum.dart';
import '../local/entities/partner_entity.dart';
import '../models/response/common/partner_info_response.dart';

class PartnerProfileService {
  final PartnerLocalDataSource _localDataSource =
      PartnerLocalDataSource.instance;

  Future<PartnerEntity> saveProfile(PartnerInfoResponse response) async {
    final gender = response.gender;

    final partnerEntity = PartnerEntity(
      id: response.id,
      name: response.name,
      birthday: response.birthday,
      gender: gender != null ? Gender.fromServerValue(gender) : null,
      updatedAt: response.updatedAt,
    );

    _localDataSource.savePartner(partnerEntity);

    return partnerEntity;
  }
}
