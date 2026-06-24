import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/utils/image_utils.dart';

class CrearPublicacionService {
  // Crear la publicación y devolver el ID
  Future<String?> crearPublicacion(
      Map<String, dynamic> datosPublicacion) async {
    final response = await http.post(
      Uri.parse(ApiConstants.createPublicacion),
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
      Uri.parse(ApiConstants.updatePublicacion(idPublicacion)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fotos": urls}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al actualizar fotos: ${response.body}');
    } else {
      return true;
    }
  }

  Future<List<String>> subirImagenesAFirebase(
      String publicacionId, List<File> localImages) async {
    List<String> urls = [];

    for (final imagen in localImages) {
      // Convertir a WebP antes de subir
      final imagenWebP = await ImageUtils.convertToAWebP(imagen);

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
