import 'package:flutter/material.dart';
import 'posts_service.dart';

class PostsController extends ChangeNotifier {
  final PostsService _service;
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedIndex = 0;

  String? highlightedPostId;
  int? _requestedHomeTab;
  int? get requestedHomeTab => _requestedHomeTab;

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

  void highlightPost(String? id) {
    highlightedPostId = id;
    notifyListeners();
  }

  void clearHighlight() {
    highlightedPostId = null;
    notifyListeners();
  }

  void requestHomeTab(int index) {
    _requestedHomeTab = index;
    notifyListeners();
  }

  void consumeHomeTab() {
    _requestedHomeTab = null;
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  List<dynamic> filterPosts(String estado) {
    final filtered = _posts
        .where((pub) => pub['status'] == estado.toLowerCase())
        .toList();
    filtered.sort((a, b) {
      final dateA = DateTime.tryParse(a['postDate'] ?? '') ?? DateTime(0);
      final dateB = DateTime.tryParse(b['postDate'] ?? '') ?? DateTime(0);
      return dateB.compareTo(dateA);
    });
    return filtered;
  }

  int countByStatus(String estado) =>
      _posts.where((p) => p['status'] == estado.toLowerCase()).length;

  bool get hasPublications => _posts.isNotEmpty;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
