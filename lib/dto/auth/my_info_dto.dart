class MyInfoDto {
  String id;
  String name;
  String? birthday; // 날짜 ex) 1997-03-10
  String? gender;
  String? profileImageUrl;
  String provider;
  String updatedAt; // 날짜 timestamp

  MyInfoDto({
      required this.id
    , required this.name
    , this.birthday
    , this.gender
    , this.profileImageUrl
    , required this.provider
    , required this.updatedAt
  });

  factory MyInfoDto.fromJson(Map<String, dynamic> json) {
    return MyInfoDto(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      provider: json['provider'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  String toString() {
    return 'MyInfo{id: $id, name: $name, birthday: $birthday gender: $gender, profileImageUrl: $profileImageUrl, provider: $provider, updatedAt: $updatedAt}';
  }


}