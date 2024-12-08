import '../api_dto.dart';
import '../auth/my_info_dto.dart';
import '../couple/couple_info_dto.dart';

class UserProfileDto extends ApiResponse {
  MyInfoDto me;
  CoupleInfoDto? coupleInfo;

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
      me: MyInfoDto.fromJson(json['data']['me']),
      coupleInfo: json['data']['coupleInfo'] != null
          ? CoupleInfoDto.fromJson(json['data']['coupleInfo'])
          : null,
    );
  }

  @override
  String toString() {
    return 'LoginResponseDto{status: $status, error: $error, me: $me, coupleInfo: $coupleInfo}';
  }
}
