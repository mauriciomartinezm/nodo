import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CrearPublicacionService {
  // Crear la publicación y devolver el ID
  Future<String?> crearPublicacion(
      Map<String, dynamic> datosPublicacion) async {
    final response = await http.post(
      Uri.parse(ApiConstants.createPublicacionEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(datosPublicacion),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // asegúrate de que tu backend devuelva esto
    } else {
      throw Exception('Error al crear publicación: ${response.body}');
    }
  }

  // Actualizar las URLs de las fotos
  Future<bool> actualizarFotos(String idPublicacion, List<String> urls) async {
    final response = await http.put(
      Uri.parse(ApiConstants.updatePublicacionEndpoint(idPublicacion)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fotos": urls}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al actualizar fotos: ${response.body}');
    } else {
      return true;
    }
  }

  // 🔹 Subprograma: Convertir imágenes a WebP antes de subir
  Future<File> convertirAWebP(File original) async {
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

  Future<List<String>> subirImagenesAFirebase(
      String publicacionId, List<File> localImages) async {
    List<String> urls = [];

    for (final imagen in localImages) {
      // Convertir a WebP antes de subir
      final imagenWebP = await convertirAWebP(imagen);

      final nombreArchivo = basename(imagenWebP.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('publicaciones/$publicacionId/$nombreArchivo');

      final uploadTask = ref.putFile(imagenWebP);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);

      // Eliminar archivo temporal después de subir
      if (await imagenWebP.exists()) {
        await imagenWebP.delete();
      }
    }

    return urls;
  }
}
