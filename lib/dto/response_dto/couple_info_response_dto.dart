import 'package:couple_book/dto/api_dto.dart';
import 'package:couple_book/dto/couple/couple_info_dto.dart';

class CoupleInfoResponse extends ApiResponse {
  CoupleInfoDto coupleInfo;

  CoupleInfoResponse({
      required super.status
    , required super.error
    , required this.coupleInfo
  });

  factory CoupleInfoResponse.fromJson(Map<String, dynamic> json) {
    return CoupleInfoResponse(
        status: json['status'],
        error: json['error'],
        coupleInfo: CoupleInfoDto.fromJson(json['data']['coupleInfo'])
    );
  }
}