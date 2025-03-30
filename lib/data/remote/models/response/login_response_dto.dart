import 'package:couple_book/data/remote/models/response/common/couple_info_response.dart';
import 'package:couple_book/data/remote/models/response/common/my_info_response.dart';
import 'package:couple_book/data/remote/models/common/api_dto.dart';

class LoginResponseDto extends ApiResponse {
  MyInfoResponse me;
  CoupleInfoResponse? coupleInfo;
  String accessToken;
  String refreshToken;

  LoginResponseDto(
      {required super.status, required super.error, required this.me, this.coupleInfo, required this.accessToken, required this.refreshToken});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json, String accessToken, String refreshToken) {
    return LoginResponseDto(
      status: json['status'],
      error: json['error'],
      me: MyInfoResponse.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null ? CoupleInfoResponse.fromJson(json['data']['coupleInfo']) : null,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  String toString() {
    return 'LoginResponseDto{status: $status, error: $error, me: $me, coupleInfo: $coupleInfo, accessToken: $accessToken}';
  }
}
