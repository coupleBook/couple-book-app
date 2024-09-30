import 'package:couple_book/dto/api_dto.dart';
import 'package:couple_book/dto/auth/couple_info.dart';

class CoupleInfoResponse extends ApiResponse {
  CoupleInfo coupleInfo;

  CoupleInfoResponse({
      required super.status
    , required super.error
    , required this.coupleInfo
  });

  factory CoupleInfoResponse.fromJson(Map<String, dynamic> json) {
    return CoupleInfoResponse(
        status: json['status'],
        error: json['error'],
        coupleInfo: CoupleInfo.fromJson(json['data']['coupleInfo'])
    );
  }
}