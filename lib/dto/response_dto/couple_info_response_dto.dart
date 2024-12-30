import 'package:couple_book/dto/api_dto.dart';
import 'package:couple_book/data/models/response/common/couple_info_response.dart';

class CoupleInfoResponseModel extends ApiResponse {
  CoupleInfoResponse coupleInfo;

  CoupleInfoResponseModel({
      required super.status
    , required super.error
    , required this.coupleInfo
  });

  factory CoupleInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return CoupleInfoResponseModel(
        status: json['status'],
        error: json['error'],
        coupleInfo: CoupleInfoResponse.fromJson(json['data']['coupleInfo'])
    );
  }
}