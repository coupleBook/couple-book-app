class AuthEntity {
  final String accessToken;
  final String refreshToken;

  AuthEntity({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
    accessToken: json['accessToken'],
    refreshToken: json['refreshToken'],
  );
}
