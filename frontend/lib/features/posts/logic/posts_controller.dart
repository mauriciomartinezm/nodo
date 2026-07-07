import 'package:flutter/material.dart';
import 'posts_service.dart';

class PostsController extends ChangeNotifier {
  final PostsService _service;
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedIndex = 0;

  PostsController(this._service);

  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get selectedIndex => _selectedIndex;

  Future<void> loadPosts() async {
    try {
      _setLoading(true);
      _posts = await _service.getPostsByUserId();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _posts = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      _setLoading(true);
      final success = await _service.deletePost(postId);
      if (success) {
        await loadPosts(); // Recargar la lista después de eliminar
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePost(
      String postId, Map<String, dynamic> updatedFields) async {
    try {
      _setLoading(true);
      final success =
          await _service.updatePost(postId, updatedFields);

      if (success) {
        await loadPosts(); // Refresca la lista
      }
      return success;
    } catch (e) {
      _errorMessage = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> finishJob(String postId) async {
    try {
      _setLoading(true);
      final success = await _service.finishJob(postId);
      if (success) {
        await loadPosts(); // Recarga la lista si todo va bien
      } else {
        _errorMessage = 'No se pudo finalizar el trabajo o la postulación.';
      }
      return success;
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

  List<dynamic> filterPosts(String estado) {
    return _posts
        .where((pub) => pub['status'] == estado.toLowerCase())
        .toList();
  }

  bool get hasPublications => _posts.isNotEmpty;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
