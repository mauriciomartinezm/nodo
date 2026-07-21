import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/shared/providers/user_provider.dart';

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
        if (!context.mounted) return;
        // Limpia todo el stack (welcome/register/login acumulados), no solo
        // el tope: si no, Home puede no quedar como primera ruta y un
        // popUntil(isFirst) posterior termina mostrando un login viejo.
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_cleanMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _cleanMessage(Object error) {
    final text = error.toString();
    return text.startsWith('Exception: ') ? text.substring(11) : text;
  }
}
