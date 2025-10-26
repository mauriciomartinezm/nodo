import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/providers/register_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/user_provider.dart';

class ProfilePictureController extends ChangeNotifier {
  bool acceptedTerms = false;
  File? imageFile;
  bool isLoading = false;

  /// Seleccionar imagen desde galería
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// Subir imagen a Firebase Storage
  Future<String> subirImagenAFirebase(File imagen, String cedula) async {
    debugPrint("Subiendo imagen para el usuario: $cedula");
    try {
      final nombreArchivo = '${cedula}_${path.basename(imagen.path)}';
      final ref = FirebaseStorage.instance.ref().child('perfiles/$nombreArchivo');

      final uploadTask = ref.putFile(imagen);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint("Error al subir imagen: $e");
      rethrow;
    }
  }

  /// Enviar URL de la imagen al backend
  Future<void> enviarImagenAlBackend(String id, String urlFoto) async {
    debugPrint("Enviando URL de imagen al backend para el usuario: $id");
    final String apiUrl = ApiConstants.updateUsuarioEndpoint(id);
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'foto_perfil': urlFoto}),
      );

      if (response.statusCode != 200) {
        debugPrint('Error al actualizar imagen: ${response.body}');
      }
    } catch (e) {
      debugPrint('Excepción al enviar imagen: $e');
    }
  }

  /// Confirmar acción final del registro
  Future<bool> confirmar(BuildContext context) async {
    if (!acceptedTerms || isLoading) return false;

    isLoading = true;
    notifyListeners();

    try {
      final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
      final id = registerProvider.id;

      if (id == null) throw Exception('ID de usuario no encontrado');

      final urlImagen = imageFile != null
          ? await subirImagenAFirebase(imageFile!, id)
          : "https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/perfiles%2FiconNodoBlue.png?alt=media&token=22b11580-c0ac-403e-89e3-5f09cc5cd25c";

      await enviarImagenAlBackend(id, urlImagen);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen_welcome', true);

      return true;
    } catch (e) {
      debugPrint('Error en confirmar: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar el estado de aceptación de términos
  void toggleAccepted(bool? value) {
    acceptedTerms = value ?? false;
    notifyListeners();
  }
}
