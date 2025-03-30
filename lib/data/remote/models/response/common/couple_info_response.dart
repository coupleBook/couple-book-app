import 'partner_info_response.dart';

class CoupleInfoResponse {
  String coupleId;
  DateTime datingAnniversary;
  String? updatedAt;
  PartnerInfoResponse partner;

  CoupleInfoResponse({required this.coupleId, required this.datingAnniversary, this.updatedAt, required this.partner});

  Map<String, dynamic> toJson() {
    return {
      'coupleId': coupleId,
      'datingAnniversary': datingAnniversary.toIso8601String(),
      'updatedAt': updatedAt,
      'partner': partner.toJson(),
    };
  }

  factory CoupleInfoResponse.fromJson(Map<String, dynamic> json) {
    return CoupleInfoResponse(
      coupleId: json['coupleId'],
      datingAnniversary: DateTime.parse(json['datingAnniversary']),
      updatedAt: json['updatedAt'],
      partner: PartnerInfoResponse.fromJson(json['partner']),
    );
  }
}
