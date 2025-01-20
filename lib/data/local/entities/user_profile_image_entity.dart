class UserProfileImageEntity {
  final String filePath;
  final int version;

  UserProfileImageEntity({required this.filePath, required this.version});

  Map<String, dynamic> toJson() => {
    'filePath': filePath,
    'version': version,
  };

  factory UserProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      UserProfileImageEntity(
        filePath: json['filePath'],
        version: json['version'],
      );
}
