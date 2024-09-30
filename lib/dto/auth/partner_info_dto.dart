class PartnerInfoDto {
  String id;
  String name;
  String? datingAnniversary; // 날짜
  String? gender;
  String? profileImageUrl;
  String provider;

  PartnerInfoDto({
      required this.id
    , required this.name
    , this.datingAnniversary
    , this.gender
    , this.profileImageUrl
    , required this.provider
  });

  factory PartnerInfoDto.fromJson(Map<String, dynamic> json) {
    return PartnerInfoDto(
      id: json['id'],
      name: json['name'],
      datingAnniversary: json['datingAnniversary'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      provider: json['provider'],
    );
  }

}