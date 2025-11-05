import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:nodo/core/services/auth_service.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isWorker => _user?.tipoUsuario == 'trabajador';

  final AuthService _authService = AuthService();

  Future<void> login(String identificador, String contrasena) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.login(identificador, contrasena);
      debugPrint("usuario devuelto de db: ");

      debugPrint(const JsonEncoder.withIndent('  ').convert(user!.toJson()));

      _user = user; 
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_user == null) return;
    await _authService.logout(_user!.id);
    _user = null;
    notifyListeners();
  }

  void updateUsuario(User usuario) {
    _user = usuario;
    notifyListeners();
  }
}
