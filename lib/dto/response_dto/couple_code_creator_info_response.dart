import 'package:couple_book/dto/api_dto.dart';

class CoupleCodeCreatorInfoResponse extends ApiResponse {
  String code;
  String username;
  String? birthday;
  String? gender;
  String datingAnniversary;

  CoupleCodeCreatorInfoResponse(
      {required super.status,
      required super.error,
      required this.code,
      required this.username,
      this.birthday,
      this.gender,
      required this.datingAnniversary});

  factory CoupleCodeCreatorInfoResponse.fromJson(Map<String, dynamic> json) {
    return CoupleCodeCreatorInfoResponse(
        status: json['status'],
        error: json['error'],
        code: json['data']['code'],
        username: json['data']['username'],
        birthday: json['data']['birthday'],
        gender: json['gender'],
        datingAnniversary: json['data']['datingAnniversary']);
  }
}
