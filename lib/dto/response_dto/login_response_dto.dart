import 'package:couple_book/dto/api_dto.dart';
import 'package:couple_book/dto/auth/my_info.dart';

import '../auth/couple_info.dart';

class LoginResponseDto extends ApiResponse {
  MyInfo me;
  CoupleInfo? coupleInfo;
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
      me: MyInfo.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null
          ? CoupleInfo.fromJson(json['data']['coupleInfo'])
          : null,
      accessToken: accessToken,
    );
  }

  @override
  String toString() {
    return 'LoginResponseDto{status: $status, error: $error, me: $me, coupleInfo: $coupleInfo, accessToken: $accessToken}';
  }
}