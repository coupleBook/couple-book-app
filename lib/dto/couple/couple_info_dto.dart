import 'package:couple_book/dto/auth/partner_info_dto.dart';

class CoupleInfoDto {
  String coupleId;
  DateTime datingAnniversary;
  String? updatedAt;
  PartnerInfoDto partner;

  CoupleInfoDto({
      required this.coupleId
    , required this.datingAnniversary
    , this.updatedAt
    , required this.partner
  });

  factory CoupleInfoDto.fromJson(Map<String, dynamic> json) {
    return CoupleInfoDto(
      coupleId: json['coupleId'],
      datingAnniversary: DateTime.parse(json['datingAnniversary']),
      updatedAt: json['updatedAt'],
      partner: PartnerInfoDto.fromJson(json['partner']),
    );
  }
}