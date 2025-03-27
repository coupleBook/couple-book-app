class LocalUserInfo {
  final String? anniversary; // 처음 만난 날 yyyy-MM-dd

  LocalUserInfo({this.anniversary});

  Map<String, dynamic> toJson() => {
        'anniversary': anniversary,
      };

  factory LocalUserInfo.fromJson(Map<String, dynamic> json) => LocalUserInfo(anniversary: json['anniversary']);

  LocalUserInfo copyWith({String? anniversary}) {
    return LocalUserInfo(
      anniversary: anniversary ?? this.anniversary,
    );
  }
}
