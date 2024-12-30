class PartnerProfileImageEntity {
  final String fileName;
  final int version;

  PartnerProfileImageEntity({required this.fileName, required this.version});

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'version': version,
  };

  factory PartnerProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      PartnerProfileImageEntity(
        fileName: json['fileName'],
        version: json['version'],
      );
}
