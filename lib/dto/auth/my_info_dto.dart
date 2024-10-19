class MyInfoDto {
  String? id;
  String name;
  String? birthday; // 날짜 ex) 1997-03-10
  String? gender;
  int? profileImageVersion;
  String? provider;
  String? updatedAt; // 날짜 timestamp

  MyInfoDto({
      this.id
    , required this.name
    , this.birthday
    , this.gender
    , this.profileImageVersion
    , this.provider
    , this.updatedAt
  });

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

  factory MyInfoDto.fromJson(Map<String, dynamic> json) {
    return MyInfoDto(
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