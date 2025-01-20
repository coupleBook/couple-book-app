import '../../dto/api_dto.dart';

class ProfileModificationResponseDto extends ApiResponse {
  String id;
  String name;
  String? birthdate;
  String? gender;
  DateTime updatedAt;

  ProfileModificationResponseDto({
    required super.status,
    required super.error,
    required this.id,
    required this.name,
    this.birthdate,
    this.gender,
    required this.updatedAt,
  });

  factory ProfileModificationResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileModificationResponseDto(
      status: json['status'],
      error: json['error'],
      id: json['data']['id'],
      name: json['data']['name'],
      birthdate: json['data']['birthdate'],
      gender: json['data']['gender'],
      updatedAt: DateTime.parse(json['data']['updatedAt']),
    );
  }
}
