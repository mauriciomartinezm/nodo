import 'package:flutter/material.dart';
import 'publicaciones_service.dart';

class PublicacionesController extends ChangeNotifier {
  final PublicacionesService _service;
  List<dynamic> _publicaciones = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedIndex = 0;

  PublicacionesController(this._service);

  List<dynamic> get publicaciones => _publicaciones;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get selectedIndex => _selectedIndex;

  Future<void> loadPublicaciones() async {
    try {
      _setLoading(true);
      _publicaciones = await _service.getPublicacionesByUserId();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _publicaciones = [];
    } finally {
      _setLoading(false);
    }
  }
  Future<bool> deletePublicacion(String publicacionId) async {
    try {
      _setLoading(true);
      final success = await _service.deletePublicacion(publicacionId);
      if (success) {
        await loadPublicaciones(); // Recargar la lista después de eliminar
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  List<dynamic> filterPublicaciones(String estado) {
    return _publicaciones.where((pub) => pub['estado'] == estado.toLowerCase()).toList();
  }

  bool get hasPublications => _publicaciones.isNotEmpty;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}