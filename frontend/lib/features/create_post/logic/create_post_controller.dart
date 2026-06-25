import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nodo/features/create_post/logic/create_post_service.dart';
import 'package:nodo/shared/providers/user_provider.dart';

class CreatePostController extends ChangeNotifier {
  final CreatePostService _service;

  CreatePostController(this._service);

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
  List<String> imageUrls = []; // URLs tras subida

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void toggleCategory(String categoryId) {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }
    notifyListeners();
  }

  void setCategories(List<String> categoryIds) {
    selectedCategories = categoryIds;
    notifyListeners();
  }

  void setLocalImages(List<File> files) {
    localImages = files;
    notifyListeners();
  }

  void clearForm() {
    tituloController.clear();
    ubicacionController.clear();
    presupuestoController.clear();
    fechaLimiteController.clear();
    descripcionController.clear();
    selectedCategories.clear();
    localImages.clear();
    imageUrls.clear();
    errorMessage = null;
    notifyListeners();
  }

  bool validateFields() {
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

  Future<void> createPost(
    BuildContext context,
    UserProvider userProvider,
  ) async {
    if (!validateFields()) return;

    try {
      setLoading(true);

      final data = {
        "clientId": userProvider.user?.id,
        "title": tituloController.text,
        "specificCategoryIds": selectedCategories,
        "location": ubicacionController.text,
        "budget": int.tryParse(presupuestoController.text) ?? 0,
        "deadline": fechaLimiteController.text,
        "description": descripcionController.text,
      };

      final id = await _service.createPost(data);
      // 🔹 Subir imágenes solo ahora
      final urls = await _service.uploadImagesToFirebase(id!, localImages);
      // 2️⃣ Actualizar con fotos si existen
      if (urls.isNotEmpty) {
        await _service.updatePhotos(id, urls);
      }
      clearForm();
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
