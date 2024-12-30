import '../../models/response/common/my_info_response.dart';
import 'enums/gender_enum.dart';

class UserEntity {
  final String id;
  final String name;
  final String? birthday;
  final Gender? gender;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.birthday,
    required this.gender,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'birthday': birthday,
        'gender': gender?.toServerValue(),
        'lastUpdated': updatedAt.toIso8601String(),
      };

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'] != null
          ? Gender.fromServerValue(json['gender'])
          : null,
      updatedAt: DateTime.parse(json['updatedAt']));

  factory UserEntity.fromMyInfoResponse(MyInfoResponse response) => UserEntity(
      id: response.id,
      name: response.name,
      birthday: response.birthday,
      gender: response.gender != null
          ? Gender.fromServerValue(response.gender!)
          : null,
      updatedAt: DateTime.parse(response.updatedAt!));
}
