import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/user_provider.dart';

class LoginController {
  final BuildContext context;
  LoginController(this.context);

  Future<void> login(String identificador, String contrasena) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (identificador.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      await userProvider.login(identificador, contrasena);
      if (userProvider.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
