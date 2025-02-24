import '../../../api/couple_api/create_couple_code_response_dto.dart';

class CoupleCodeEntity {
  final String code;
  final DateTime expirationAt;

  CoupleCodeEntity({required this.code, required this.expirationAt});

  Map<String, dynamic> toJson() => {
        'code': code,
        'expirationAt': expirationAt.toIso8601String(),
      };

  factory CoupleCodeEntity.fromJson(Map<String, dynamic> json) =>
      CoupleCodeEntity(
        code: json['code'],
        expirationAt: DateTime.parse(json['expirationAt']),
      );

  factory CoupleCodeEntity.fromDto(CreateCoupleCodeResponseDto dto) =>
      CoupleCodeEntity(
        code: dto.code,
        expirationAt:
            DateTime.now().add(Duration(seconds: dto.expirationTimeInSeconds)),
      );

  /// 현재 시각과 비교하여 코드가 유효한지 확인하는 함수
  bool isValid() {
    return expirationAt.isAfter(DateTime.now());
  }
}
