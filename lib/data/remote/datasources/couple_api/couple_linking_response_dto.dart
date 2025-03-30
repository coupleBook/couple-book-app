import 'package:couple_book/data/remote/models/common/api_dto.dart';
import 'package:couple_book/data/remote/models/common/error_response.dart';
import 'package:couple_book/data/remote/models/response/common/couple_info_response.dart';

class CoupleLinkingResponseDto extends ApiResponse {
  CoupleInfoResponse? coupleInfo;

  CoupleLinkingResponseDto({required super.status, required super.error, required this.coupleInfo});

  factory CoupleLinkingResponseDto.fromJson(Map<String, dynamic> json) {
    return CoupleLinkingResponseDto(
        status: json['status'], error: json['error'], coupleInfo: CoupleInfoResponse.fromJson(json['data']['coupleInfo']));
  }

  factory CoupleLinkingResponseDto.failure({
    required String code,
    required String message,
  }) {
    return CoupleLinkingResponseDto(
      status: 'FAILURE',
      error: ErrorResponse(code: code, message: message),
      coupleInfo: null,
    );
  }
}
