// providers/usuario_provider.dart
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/trabajador.dart';

enum TipoUsuario { ninguno, cliente, trabajador }

class UsuarioProvider with ChangeNotifier {
  Cliente? _cliente;
  Trabajador? _trabajador;
  TipoUsuario _tipo = TipoUsuario.ninguno;

  TipoUsuario get tipo => _tipo;
  Cliente? get cliente => _cliente;
  Trabajador? get trabajador => _trabajador;

  void loginComoCliente(Cliente c) {
    _cliente = c;
    _trabajador = null;
    _tipo = TipoUsuario.cliente;
    notifyListeners();
  }

  void loginComoTrabajador(Trabajador t, Cliente c) {
    _trabajador = t;
    _cliente = c;
    _tipo = TipoUsuario.trabajador;
    notifyListeners();
  }

  void logout() {
    _cliente = null;
    _trabajador = null;
    _tipo = TipoUsuario.ninguno;
    notifyListeners();
  }
}
