import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _cedula = '';
  bool _isWorker = false;

  String get cedula => _cedula;
  bool get isWorker => _isWorker;

  void setCedula(String value) {
    _cedula = value;
    notifyListeners();
  }

  void setIsWorker(bool value) {
    _isWorker = value;
    notifyListeners();
  }

  void clearUser() {
    _cedula = '';
    _isWorker = false;
    notifyListeners();
  }
}
