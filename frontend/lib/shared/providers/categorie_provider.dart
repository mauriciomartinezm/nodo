import 'package:flutter/foundation.dart';
import 'package:nodo/core/services/categorie_service.dart';
import 'package:nodo/models/categorie.dart';

class CategorieProvider extends ChangeNotifier {
  final CategorieService _service = CategorieService();

  List<Categorie> _categories = [];
  bool _isLoading = false;
  bool _loaded = false;

  List<Categorie> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> cargarCategorias() async {
    debugPrint('Cargando categorías en el provider...');
    if (_loaded) return; // ⚡ evita múltiples peticiones

    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.obtenerCategorias();
      _loaded = true;
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Categorie? obtenerPorId(String id) {
    return _categories.firstWhere(
      (c) => c.id == id,
      orElse: () => Categorie(id: '', name: 'Unknown'),
    );
  }
}
