import 'package:couple_book/data/local/entities/enums/login_platform.dart';

class LastLoginEntity {
  final String loginId;
  final LoginPlatform platform;

  LastLoginEntity({required this.loginId, required this.platform});

  Map<String, dynamic> toJson() => {
        'loginId': loginId,
        'platform': platform.name,
      };

  factory LastLoginEntity.fromJson(Map<String, dynamic> json) =>
      LastLoginEntity(
        loginId: json['loginId'],
        platform: LoginPlatform.fromServerValue(json['platform']),
      );
}
