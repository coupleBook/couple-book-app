import 'package:couple_book/data/remote/models/common/api_dto.dart';

class ProfileImageResponseDto extends ApiResponse {
  final String profileImageUrl;
  final int profileImageVersion;

  ProfileImageResponseDto({
    required super.status,
    required super.error,
    required this.profileImageUrl,
    required this.profileImageVersion,
  });

  factory ProfileImageResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponseDto(
      status: json['status'],
      error: json['error'],
      profileImageUrl: json['data']['profileImageUrl'],
      profileImageVersion: json['data']['profileImageVersion'],
    );
  }
}
