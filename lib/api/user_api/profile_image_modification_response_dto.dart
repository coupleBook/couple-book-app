import '../../dto/api_dto.dart';

class ProfileImageModificationResponseDto extends ApiResponse {
  final String profileImageUrl;
  final int profileImageVersion;

  ProfileImageModificationResponseDto({
    required super.status,
    required super.error,
    required this.profileImageUrl,
    required this.profileImageVersion,
  });

  factory ProfileImageModificationResponseDto.fromJson(
      Map<String, dynamic> json) {
    return ProfileImageModificationResponseDto(
      status: json['status'],
      error: json['error'],
      profileImageUrl: json['data']['profileImageUrl'],
      profileImageVersion: json['data']['profileImageVersion'],
    );
  }
}
