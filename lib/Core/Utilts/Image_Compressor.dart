import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCompressor {
  /// Compresses an image file and returns the compressed file
  ///
  /// [file] - The original image file to compress
  /// [quality] - Compression quality (0-100), default is 80
  /// [minWidth] - Minimum width of the output image, default is 1024
  /// [minHeight] - Minimum height of the output image, default is 1024
  ///
  /// Returns a [File] with the compressed image
  static Future<File?> compressImage({
    required File file,
    int quality = 80,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = p.join(dir.path,
          'compressed_${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}');

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  /// Check if the file is an image based on extension
  static bool isImage(String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp', '.heic'].contains(extension);
  }
}