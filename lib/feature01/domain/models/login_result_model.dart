import 'package:couple_book/data/models/response/common/couple_info_response.dart';
import 'package:couple_book/data/models/response/common/my_info_response.dart';
import 'package:couple_book/feature01/domain/models/auth_model.dart';

class LoginResultModel {
  final AuthModel auth;
  final MyInfoResponse user;
  final CoupleInfoResponse? coupleInfo;

  LoginResultModel({
    required this.auth,
    required this.user,
    this.coupleInfo,
  });
}
