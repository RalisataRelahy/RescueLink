import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rescuelink/core/constants/app_constants.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(source: source);
  }

  static Future<File?> compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: AppConstants.mediumQuality,
        minWidth: AppConstants.mediumMaxDimension,
        minHeight: AppConstants.mediumMaxDimension,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (_) {
      return file;
    }
  }
}
