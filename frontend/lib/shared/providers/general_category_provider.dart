import 'package:flutter/foundation.dart';
import 'package:nodo/core/services/general_category_service.dart';
import 'package:nodo/models/categorie.dart';

class GeneralCategoryProvider extends ChangeNotifier {
  final GeneralCategoryService _service = GeneralCategoryService();

  List<Categorie> _categories = [];
  bool _isLoading = false;
  bool _loaded = false;

  List<Categorie> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> cargarCategorias() async {
    debugPrint('Cargando categorías generales en el provider...');
    if (_loaded) return;

    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.obtenerCategorias();
      _loaded = true;
    } catch (e) {
      debugPrint('Error al cargar categorías generales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
