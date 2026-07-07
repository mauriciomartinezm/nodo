import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/utils/image_utils.dart';

class CreatePostService {
  // Crear la publicación y devolver el ID
  Future<String?> createPost(
      Map<String, dynamic> postData) async {
    final response = await http.post(
      Uri.parse(ApiConstants.createPost),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // asegúrate de que tu backend devuelva esto
    } else {
      String mensaje = 'No se pudo crear la publicación.';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) mensaje = body['message'];
      } catch (_) {}
      throw Exception(mensaje);
    }
  }

  // Actualizar las URLs de las fotos
  Future<bool> updatePhotos(String postId, List<String> urls) async {
    final response = await http.put(
      Uri.parse(ApiConstants.updatePost(postId)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"photos": urls}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('No se pudieron guardar las fotos de la publicación.');
    } else {
      return true;
    }
  }

  // Borra una publicación. Se usa para deshacer la creación si algo falla
  // después (p. ej. la subida de imágenes), así no queda una publicación
  // huérfana sin fotos.
  Future<void> deletePost(String postId) async {
    await http.delete(Uri.parse(ApiConstants.deletePost(postId)));
  }

  Future<List<String>> uploadImagesToFirebase(
      String postId, List<File> localImages) async {
    List<String> urls = [];

    try {
      for (final imagen in localImages) {
        // Convertir a WebP antes de subir
        final imagenWebP = await ImageUtils.convertToAWebP(imagen);

        final fileName = basename(imagenWebP.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('publicaciones/$postId/$fileName');

        final uploadTask = ref.putFile(imagenWebP);
        final snapshot = await uploadTask;
        final url = await snapshot.ref.getDownloadURL();
        urls.add(url);

        // Eliminar archivo temporal después de subir
        if (await imagenWebP.exists()) {
          await imagenWebP.delete();
        }
      }
    } catch (e) {
      throw Exception('No se pudo cargar la imagen. Inténtalo de nuevo.');
    }

    return urls;
  }
}
