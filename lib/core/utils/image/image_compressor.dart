import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = Logger();

class ImageCompressor {
  static Future<XFile?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // 압축 품질 (0~100, 낮을수록 압축률 높음)
      );

      return compressedFile;
    } catch (e) {
      logger.e("이미지 압축 중 오류 발생: $e");
      return null;
    }
  }
} 