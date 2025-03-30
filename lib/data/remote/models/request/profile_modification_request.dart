import 'package:couple_book/data/local/entities/enums/gender_enum.dart';

class ProfileModificationRequest {
  String name;
  String? birthday;
  Gender? gender;

  ProfileModificationRequest({
    required this.name,
    this.birthday,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday,
      'gender': gender?.toServerValue(),
    };
  }
}