class MyProfileImageDTO {
  final String fileName;
  final int profileImageVersion;

  MyProfileImageDTO({
    required this.fileName,
    required this.profileImageVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'profileImageVersion': profileImageVersion,
    };
  }

  factory MyProfileImageDTO.fromJson(Map<String, dynamic> json) {
    return MyProfileImageDTO(
      fileName: json['fileName'],
      profileImageVersion: json['profileImageVersion'],
    );
  }
}
