class AuthInfo {
  final String accessToken;
  final String refreshToken;

  AuthInfo({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) => AuthInfo(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
