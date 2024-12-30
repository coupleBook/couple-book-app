class UserProfileImageEntity {
  final String fileName;
  final int version;

  UserProfileImageEntity({required this.fileName, required this.version});

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'version': version,
  };

  factory UserProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      UserProfileImageEntity(
        fileName: json['fileName'],
        version: json['version'],
      );
}
