class PartnerInfoDto {
  String id;
  String name;
  String? birthday; // 날짜
  String? gender;
  String? profileImageUrl;
  String provider;

  PartnerInfoDto({
      required this.id
    , required this.name
    , this.birthday
    , this.gender
    , this.profileImageUrl
    , required this.provider
  });

  factory PartnerInfoDto.fromJson(Map<String, dynamic> json) {
    return PartnerInfoDto(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      provider: json['provider'],
    );
  }
}