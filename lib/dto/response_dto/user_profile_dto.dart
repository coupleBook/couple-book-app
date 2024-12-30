import '../../data/models/response/common/couple_info_response.dart';
import '../../data/models/response/common/my_info_response.dart';
import '../api_dto.dart';

class UserProfileDto extends ApiResponse {
  MyInfoResponse me;
  CoupleInfoResponse? coupleInfo;

  UserProfileDto({
    required super.status,
    required super.error,
    required this.me,
    this.coupleInfo,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
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
