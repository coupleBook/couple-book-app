class CoupleCodeEntity {
  final String code;
  final DateTime createdAt;

  CoupleCodeEntity({required this.code, required this.createdAt});

  Map<String, dynamic> toJson() => {
    'code': code,
    'createdAt': createdAt,
  };

  factory CoupleCodeEntity.fromJson(Map<String, dynamic> json) =>
      CoupleCodeEntity(
        code: json['code'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
