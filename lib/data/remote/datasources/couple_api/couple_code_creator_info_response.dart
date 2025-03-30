import 'package:couple_book/data/remote/models/common/api_dto.dart';

class CoupleCodeCreatorInfoResponseDto extends ApiResponse {
  String code;
  String username;
  String? birthday;
  String? gender;
  String datingAnniversary;

  CoupleCodeCreatorInfoResponseDto(
      {required super.status,
      required super.error,
      required this.code,
      required this.username,
      this.birthday,
      this.gender,
      required this.datingAnniversary});

  factory CoupleCodeCreatorInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return CoupleCodeCreatorInfoResponseDto(
        status: json['status'],
        error: json['error'],
        code: json['data']['code'],
        username: json['data']['username'],
        birthday: json['data']['birthday'],
        gender: json['gender'],
        datingAnniversary: json['data']['datingAnniversary']);
  }
}
