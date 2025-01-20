class MyInfoResponse {
  String id;
  String name;
  String? birthday; // 날짜 ex) 1997-03-10
  String? gender;
  int profileImageVersion;
  String provider;
  String updatedAt; // 날짜 timestamp

  MyInfoResponse(
      {required this.id,
      required this.name,
      this.birthday,
      this.gender,
      required this.profileImageVersion,
      required this.provider,
      required this.updatedAt});

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

  factory MyInfoResponse.fromJson(Map<String, dynamic> json) {
    return MyInfoResponse(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      profileImageVersion: json['profileImageVersion'],
      provider: json['provider'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  String toString() {
    return 'MyInfo{id: $id, name: $name, birthday: $birthday gender: $gender, profileImageVersion: $profileImageVersion, provider: $provider, updatedAt: $updatedAt}';
  }
}
