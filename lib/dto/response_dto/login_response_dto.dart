import 'package:couple_book/dto/api_dto.dart';
import 'package:couple_book/dto/auth/my_info_dto.dart';

import '../couple/couple_info_dto.dart';

class LoginResponseDto extends ApiResponse {
  MyInfoDto me;
  CoupleInfoDto? coupleInfo;
  String accessToken;

  LoginResponseDto({
      required super.status
    , required super.error
    , required this.me
    , this.coupleInfo
    , required this.accessToken
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json, String accessToken) {
    return LoginResponseDto(
      status: json['status'],
      error: json['error'],
      me: MyInfoDto.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null
          ? CoupleInfoDto.fromJson(json['data']['coupleInfo'])
          : null,
      accessToken: accessToken,
    );
  }

  @override
  String toString() {
    return 'LoginResponseDto{status: $status, error: $error, me: $me, coupleInfo: $coupleInfo, accessToken: $accessToken}';
  }
}