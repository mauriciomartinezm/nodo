import 'package:flutter/material.dart';
import 'crear_publicacion_service.dart';

class CrearPublicacionController extends ChangeNotifier {
  final CrearPublicacionService _service;
  List<Map<String, String>> _categorias = [];
  bool _isLoading = false;
  String? _errorMessage;

  CrearPublicacionController(this._service);

  List<Map<String, String>> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para establecer el mensaje de error
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> cargarCategorias() async {
    try {
      _setLoading(true);
      _categorias = await _service.obtenerCategorias();
      setErrorMessage(null);
    } catch (e) {
      setErrorMessage(e.toString());
      _categorias = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearPublicacion(Map<String, dynamic> datos) async {
    try {
      _setLoading(true);
      final success = await _service.crearPublicacion(datos);
      setErrorMessage(success ? null : "Error al crear publicación");
      return success;
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}