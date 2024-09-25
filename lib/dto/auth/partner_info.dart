class PartnerInfo {
  String id;
  String name;
  String? datingAnniversary; // 날짜
  String? gender;
  String? profileImageUrl;
  String provider;

  PartnerInfo({
      required this.id
    , required this.name
    , this.datingAnniversary
    , this.gender
    , this.profileImageUrl
    , required this.provider
  });

  factory PartnerInfo.fromJson(Map<String, dynamic> json) {
    return PartnerInfo(
      id: json['id'],
      name: json['name'],
      datingAnniversary: json['datingAnniversary'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      provider: json['provider'],
    );
  }

}