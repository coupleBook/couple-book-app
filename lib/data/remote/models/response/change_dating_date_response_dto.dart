import 'package:couple_book/data/remote/models/common/api_dto.dart';

class ChangeDatingDateResponseDto extends ApiResponse {
  String coupleId;
  String datingAnniversary;
  DateTime updatedAt;

  ChangeDatingDateResponseDto({
      required super.status
    , required super.error
    , required this.coupleId
    , required this.datingAnniversary
    , required this.updatedAt
  });

  factory ChangeDatingDateResponseDto.fromJson(Map<String, dynamic> json) {
    return ChangeDatingDateResponseDto(
      status: json['status'],
      error: json['error'],
      coupleId: json['data']['coupleId'],
      datingAnniversary: json['data']['datingAnniversary'],
      updatedAt: DateTime.parse(json['data']['updatedAt']),
    );
  }
}