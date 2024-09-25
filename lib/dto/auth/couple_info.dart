import 'package:couple_book/dto/auth/partner_info.dart';

class CoupleInfo {
  String coupleId;
  DateTime datingAnniversary;
  PartnerInfo partner;

  CoupleInfo({
      required this.coupleId
    , required this.datingAnniversary
    , required this.partner
  });

  factory CoupleInfo.fromJson(Map<String, dynamic> json) {
    return CoupleInfo(
      coupleId: json['coupleId'],
      datingAnniversary: DateTime.parse(json['datingAnniversary']),
      partner: PartnerInfo.fromJson(json['partner']),
    );
  }
}