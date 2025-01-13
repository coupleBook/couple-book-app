class PartnerInfoResponse {
  String id;
  String name;
  String? birthday; // 날짜
  String? gender;
  String? profileImageUrl;
  int profileImageVersion;
  String provider;
  String? updatedAt; // 날짜 timestamp

  PartnerInfoResponse(
      {required this.id,
      required this.name,
      this.birthday,
      this.gender,
      this.profileImageUrl,
      required this.profileImageVersion,
      required this.provider,
        this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'profileImageVersion': profileImageVersion,
      'provider': provider,
      'updatedAt': updatedAt,
    };
  }

  factory PartnerInfoResponse.fromJson(Map<String, dynamic> json) {
    return PartnerInfoResponse(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      profileImageVersion: json['profileImageVersion'],
      provider: json['provider'],
      updatedAt: json['updatedAt'],
    );
  }
}
