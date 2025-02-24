import '../../dto/api_dto.dart';

class CreateCoupleCodeResponseDto extends ApiResponse {
  String code;
  int expirationTimeInSeconds;

  CreateCoupleCodeResponseDto({
        required super.status
      , required super.error
      , required this.code
      , required this.expirationTimeInSeconds
  });

  factory CreateCoupleCodeResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateCoupleCodeResponseDto(
      status: json['status'],
      error: json['error'],
      code: json['data']['code'],
      expirationTimeInSeconds: json['data']['expirationTimeInSeconds'],
    );
  }
}
