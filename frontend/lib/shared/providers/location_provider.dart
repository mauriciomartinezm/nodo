import 'package:flutter/foundation.dart';
import 'package:nodo/core/services/location_service.dart';
import 'package:nodo/models/location.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service = LocationService();

  List<Location> _locations = [];
  bool _isLoading = false;
  bool _loaded = false;

  List<Location> get locations => _locations;
  bool get isLoading => _isLoading;

  Future<void> cargarUbicaciones() async {
    if (_loaded) return;

    _isLoading = true;
    notifyListeners();

    try {
      _locations = await _service.obtenerUbicaciones();
      _loaded = true;
    } catch (e) {
      debugPrint('Error al cargar ubicaciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
