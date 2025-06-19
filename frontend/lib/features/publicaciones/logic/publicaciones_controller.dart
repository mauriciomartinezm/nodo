import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nodo/core/constants/api_constants.dart';
import 'publicaciones_service.dart';
import 'package:http/http.dart' as http;

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

  //Sí debería exister pero para el editar - falta modificarlo
  Future<bool> updatePublicacion(
      String publicacionId, Map<String, dynamic> camposActualizados) async {
    print("❕❕❕❕Publicacion id");
    print(publicacionId);
    try {
      _setLoading(true);
      final success =
          await _service.updatePublicacion(publicacionId, camposActualizados);

      if (success) {
        await loadPublicaciones(); // Refresca la lista
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> finalizarTrabajo(String id_publicacion) async {
    print("❕❕❕❕Finalizando trabajo");

    try {
      _setLoading(true);
      final url = Uri.parse(ApiConstants.finalizarTrabajo);

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_publicacion': id_publicacion, // Usa la variable real aquí
        }),
      );
      print("STATUS CODE: ");
      print(response.statusCode);
      //final resultadoPublicacion = await updatePublicacion(publicacionId, {
      //  'estado': 'finalizada',
      //});
//
//      //final resultadoPostulacion =
      //    await _service.updatePostulacion(postulacionId, {
      //  'estado': 'finalizada',
      //});

      if (response.statusCode == 200) {
        await loadPublicaciones(); // Recarga la lista si todo va bien
        return true;
      } else {
        _errorMessage = 'No se pudo finalizar el trabajo o la postulación.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al finalizar trabajo: ${e.toString()}';
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
    return _publicaciones
        .where((pub) => pub['estado'] == estado.toLowerCase())
        .toList();
  }

  bool get hasPublications => _publicaciones.isNotEmpty;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
