import '../../models/response/common/partner_info_response.dart';
import 'enums/gender_enum.dart';

class PartnerEntity {
  final String id;
  final String name;
  final String? birthday;
  final Gender? gender;
  final DateTime updatedAt;

  PartnerEntity({
    required this.id,
    required this.name,
    required this.birthday,
    required this.gender,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'birthday': birthday,
        'gender': gender?.toServerValue(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PartnerEntity.fromJson(Map<String, dynamic> json) => PartnerEntity(
        id: json['id'],
        name: json['name'],
        birthday: json['birthday'],
        gender: Gender.fromServerValue(json['gender']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  factory PartnerEntity.fromMyInfoResponse(PartnerInfoResponse response) =>
      PartnerEntity(
        id: response.id,
        name: response.name,
        birthday: response.birthday,
        gender: response.gender != null
            ? Gender.fromServerValue(response.gender!)
            : null,
          updatedAt: DateTime.parse(response.updatedAt!)
      );
}
