import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  String? id;
  String? email;
  String? password;

  // Guardar o actualizar datos del registro
  void setRegisterData({
    String? id,
    String? email,
    String? password,
  }) {
    if (id != null) this.id = id;
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    notifyListeners();
  }

  // Limpiar cuando el registro termine o se cancele
  void clear() {
    id = null;
    email = null;
    password = null;
    notifyListeners();
  }
}
