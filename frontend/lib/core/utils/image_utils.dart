import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';


class ImageUtils {
  /// Convierte una lista de imágenes locales a formato WebP
  static Future<File> convertToAWebP(File original) async {
    final nuevoPath = original.path.replaceAll(
      basename(original.path),
      '${basenameWithoutExtension(original.path)}_compressed.webp',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      original.absolute.path,
      nuevoPath,
      quality: 80, // puedes ajustar la calidad (0-100)
      format: CompressFormat.webp,
    );

    if (result == null) {
      throw Exception('No se pudo convertir la imagen a WebP');
    }

    // Convertimos el XFile a File
    return File(result.path);
  }
}
