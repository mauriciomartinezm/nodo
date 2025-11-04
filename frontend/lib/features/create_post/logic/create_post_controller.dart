import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nodo/features/create_post/logic/create_post_service.dart';
import 'package:nodo/providers/user_provider.dart';

class CrearPublicacionController extends ChangeNotifier {
  final CrearPublicacionService _service;

  CrearPublicacionController(this._service);

  bool isLoading = false;
  String? errorMessage;

  // Campos
  final tituloController = TextEditingController();
  final ubicacionController = TextEditingController();
  final presupuestoController = TextEditingController();
  final fechaLimiteController = TextEditingController();
  final descripcionController = TextEditingController();

  List<String> selectedCategories = [];
  List<File> localImages = []; // imágenes locales
  List<String> urlsImagenes = []; // URLs tras subida

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void toggleCategoria(String idCategoria) {
    if (selectedCategories.contains(idCategoria)) {
      selectedCategories.remove(idCategoria);
    } else {
      selectedCategories.add(idCategoria);
    }
    notifyListeners();
  }

  void setLocalImages(List<File> files) {
    localImages = files;
    notifyListeners();
  }

  void limpiarFormulario() {
    tituloController.clear();
    ubicacionController.clear();
    presupuestoController.clear();
    fechaLimiteController.clear();
    descripcionController.clear();
    selectedCategories.clear();
    localImages.clear();
    urlsImagenes.clear();
    errorMessage = null;
    notifyListeners();
  }

  bool validarCampos() {
    if (tituloController.text.isEmpty ||
        selectedCategories.isEmpty ||
        ubicacionController.text.isEmpty ||
        presupuestoController.text.isEmpty ||
        fechaLimiteController.text.isEmpty ||
        descripcionController.text.isEmpty) {
      setErrorMessage("Todos los campos son obligatorios");
      return false;
    }
    setErrorMessage(null);
    return true;
  }

  Future<void> crearPublicacion(
    BuildContext context,
    UserProvider userProvider,
  ) async {
    if (!validarCampos()) return;

    try {
      setLoading(true);

      final datos = {
        "id_cliente": userProvider.user?.id,
        "titulo": tituloController.text,
        "id_categorias": selectedCategories,
        "ubicacion": ubicacionController.text,
        "presupuesto": int.tryParse(presupuestoController.text) ?? 0,
        "fecha_limite": fechaLimiteController.text,
        "descripcion_necesidad": descripcionController.text,
      };

      final id = await _service.crearPublicacion(datos);
      // 🔹 Subir imágenes solo ahora
      final urls = await _service.subirImagenesAFirebase(id!, localImages);
      // 2️⃣ Actualizar con fotos si existen
      if (urls.isNotEmpty) {
        await _service.actualizarFotos(id, urls);
      }
      limpiarFormulario();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación creada correctamente')),
      );
    } catch (e) {
      setErrorMessage("Error al crear la publicación: $e");
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    ubicacionController.dispose();
    presupuestoController.dispose();
    fechaLimiteController.dispose();
    descripcionController.dispose();
    super.dispose();
  }
}
