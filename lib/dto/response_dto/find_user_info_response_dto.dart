import 'package:couple_book/dto/api_dto.dart';

class FindUserInfoResponse extends ApiResponse{
  String code;
  String username;
  String? birthday;
  String? profileImageUrl;
  String? gender;
  String datingAnniversary;

  FindUserInfoResponse({
      required super.status
    , required super.error
    , required this.code
    , required this.username
    , this.birthday
    , this.profileImageUrl
    , this.gender
    , required this.datingAnniversary
  });

  factory FindUserInfoResponse.fromJson(Map<String, dynamic> json) {
    return FindUserInfoResponse(
        status: json['status'],
        error: json['error'],
        code: json['data']['code'],
        username: json['data']['username'],
        birthday: json['data']['birthday'],
        profileImageUrl: json['data']['profileImageUrl'],
        gender: json['gender'],
        datingAnniversary: json['data']['datingAnniversary']
    );
  }
}