import 'package:couple_book/dto/auth/partner_info_dto.dart';

class CoupleInfoDto {
  String id;
  DateTime datingAnniversary;
  String? updatedAt;
  PartnerInfoDto partner;

  CoupleInfoDto({
      required this.id
    , required this.datingAnniversary
    , this.updatedAt
    , required this.partner
  });

  factory CoupleInfoDto.fromJson(Map<String, dynamic> json) {
    return CoupleInfoDto(
      id: json['id'],
      datingAnniversary: DateTime.parse(json['datingAnniversary']),
      updatedAt: json['updatedAt'],
      partner: PartnerInfoDto.fromJson(json['partner']),
    );
  }
}