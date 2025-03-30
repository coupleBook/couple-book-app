import 'package:couple_book/data/remote/models/response/common/couple_info_response.dart';
import 'package:couple_book/data/remote/models/response/common/my_info_response.dart';

class LoginResponseModel {
  final MyInfoResponse  me;
  final CoupleInfoResponse? coupleInfo;
  final String accessToken;
  final String refreshToken;

  LoginResponseModel({
    required this.me,
    this.coupleInfo,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json, String accessToken, String refreshToken) {
    return LoginResponseModel(
      me: MyInfoResponse.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null
          ? CoupleInfoResponse.fromJson(json['data']['coupleInfo'])
          : null,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
