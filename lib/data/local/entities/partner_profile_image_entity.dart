class PartnerProfileImageEntity {
  final String filePath;
  final int version;

  PartnerProfileImageEntity({required this.filePath, required this.version});

  Map<String, dynamic> toJson() => {
    'filePath': filePath,
    'version': version,
  };

  factory PartnerProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      PartnerProfileImageEntity(
        filePath: json['filePath'],
        version: json['version'],
      );
}
