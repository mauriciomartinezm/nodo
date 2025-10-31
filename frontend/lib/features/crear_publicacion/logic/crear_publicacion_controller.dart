import 'package:flutter/material.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_service.dart';
import 'package:nodo/providers/categorie_provider.dart';
import 'package:nodo/providers/user_provider.dart';

class CrearPublicacionController extends ChangeNotifier {
  final CrearPublicacionService _service;

  CrearPublicacionController(this._service);
  // --- Estado general ---
  bool isLoading = false;
  String? errorMessage;

  // --- Campos del formulario ---
  final tituloController = TextEditingController();
  final ubicacionController = TextEditingController();
  final presupuestoController = TextEditingController();
  final fechaLimiteController = TextEditingController();
  final descripcionController = TextEditingController();

  // --- Otros datos ---
  List<String> selectedCategories = [];
  List<String> urlsImagenes = [];

  // --- Métodos de gestión del estado ---
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

  void setUrlsImagenes(List<String> urls) {
    urlsImagenes = urls;
    notifyListeners();
  }

  void limpiarFormulario() {
    tituloController.clear();
    ubicacionController.clear();
    presupuestoController.clear();
    fechaLimiteController.clear();
    descripcionController.clear();
    selectedCategories.clear();
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

  // --- Ejemplo de creación de publicación ---
  Future<bool> crearPublicacion(
    BuildContext context,
    UserProvider userProvider,
  ) async {
    if (!validarCampos()) return false;

    final datos = {
      "id_cliente": userProvider.user?.id,
      "titulo": tituloController.text,
      "id_categorias": selectedCategories,
      "ubicacion": ubicacionController.text,
      "presupuesto": int.tryParse(presupuestoController.text) ?? 0,
      "fecha_limite": fechaLimiteController.text,
      "descripcion_necesidad": descripcionController.text,
      "fotos": urlsImagenes,
    };

    try {
      setLoading(true);
      
      final success = await _service.crearPublicacion(datos);
      setErrorMessage(success ? null : "Error al crear publicación");

      setLoading(false);
      limpiarFormulario();
      return success;
    } catch (e) {
      setLoading(false);
      setErrorMessage("Error al crear la publicación");
      return false;
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
