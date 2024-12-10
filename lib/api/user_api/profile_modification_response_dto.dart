import '../../dto/api_dto.dart';

class ProfileModificationResponseDto extends ApiResponse {
  String id;
  String name;
  String? birthDate;
  String? gender;
  DateTime updatedAt;

  ProfileModificationResponseDto({
    required super.status,
    required super.error,
    required this.id,
    required this.name,
    this.birthDate,
    this.gender,
    required this.updatedAt,
  });

  factory ProfileModificationResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileModificationResponseDto(
      status: json['status'],
      error: json['error'],
      id: json['data']['id'],
      name: json['data']['name'],
      birthDate: json['data']['birthDate'],
      gender: json['data']['gender'],
      updatedAt: DateTime.parse(json['data']['updatedAt']),
    );
  }
}
