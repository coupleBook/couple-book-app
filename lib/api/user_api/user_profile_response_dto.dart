import '../../data/models/response/common/couple_info_response.dart';
import '../../data/models/response/common/my_info_response.dart';
import '../../dto/api_dto.dart';

class UserProfileResponseDto extends ApiResponse {
  MyInfoResponse me;
  CoupleInfoResponse? coupleInfo;

  UserProfileResponseDto({
    required super.status,
    required super.error,
    required this.me,
    this.coupleInfo,
  });

  factory UserProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseDto(
      status: json['status'],
      error: json['error'],
      me: MyInfoResponse.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null
          ? CoupleInfoResponse.fromJson(json['data']['coupleInfo'])
          : null,
    );
  }

  @override
  String toString() {
    return 'LoginResponseDto{status: $status, error: $error, me: $me, coupleInfo: $coupleInfo}';
  }
}
