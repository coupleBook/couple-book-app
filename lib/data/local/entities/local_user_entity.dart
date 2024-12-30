class LocalUserEntity {
  final DateTime anniversary; // 처음 만난 날 yyyy-MM-dd

  LocalUserEntity({required this.anniversary});

  Map<String, dynamic> toJson() => {
    'anniversary': anniversary,
  };

  factory LocalUserEntity.fromJson(Map<String, dynamic> json) =>
      LocalUserEntity(anniversary: json['anniversary']);
}
