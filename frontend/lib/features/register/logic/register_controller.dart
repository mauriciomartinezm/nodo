import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:nodo/shared/providers/register_provider.dart';

import 'package:provider/provider.dart';

class RegisterController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🔹 Método para registrar usuario
  Future<void> registerUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController lastName1Controller,
    required TextEditingController lastName2Controller,
    required TextEditingController idController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required String? selectedUserType,
    required VoidCallback onContinue,
    required TextEditingController phoneController,
    required TextEditingController dateController,
    required TextEditingController locationController,
    required List<String> selectedCategories,
    required TextEditingController descriptionController,
    required TextEditingController emailController,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      final id = idController.text.trim();
      final nombres = nameController.text.trim();
      final primerApellido = lastName1Controller.text.trim();
      final segundoApellido = lastName2Controller.text.trim();
      final fecha_nacimiento = dateController.text.trim();
      final contrasena = passwordController.text.trim();
      final confirmacionContrasena = confirmPasswordController.text.trim();
      final telefono = phoneController.text.trim();
      final ubicacion = selectedUserType == "trabajador" &&
              locationController.text.trim().isNotEmpty
          ? locationController.text.trim()
          : null;

      final descripcion = selectedUserType == "trabajador" &&
              descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null;

      final categorias = selectedCategories;
      final email = emailController.text.trim();

      // Validar que las contraseñas coincidan

      if (contrasena != confirmacionContrasena) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden.')),
        );
        _setLoading(false);
        return;
      }

      final registerProvider = Provider.of<RegisterProvider>(context, listen: false);

      final url = Uri.parse(ApiConstants.createUsuarioEndpoint);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": id,
          "nombres": nombres,
          "primer_apellido": primerApellido,
          "segundo_apellido": segundoApellido,
          "email": email,
          "telefono": telefono,
          "fecha_nacimiento": fecha_nacimiento,
          "contrasena": contrasena,
          "tipo_usuario": selectedUserType,
          "ubicacion": ubicacion,
          "descripcion": descripcion,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Usuario agregado: ${response.body}");
        registerProvider.setRegisterData(id: id, email: email, password: contrasena);
        // 🔹 Si el usuario es trabajador y seleccionó categorías, registrar relación
        if (selectedUserType == "trabajador" && categorias.isNotEmpty) {
          await _crearUsuarioCategoria(id, categorias);
        }
        onContinue();
      } else {
        debugPrint("❌ Error al registrar: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario.')),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión.')),
      );
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Función privada para registrar categorías del usuario
  Future<void> _crearUsuarioCategoria(
      String idUsuario, List<String> categorias) async {
    final url = Uri.parse(ApiConstants.createUsuarioCategoriaEndpoint);

      try {
        final response = await http.post(
          Uri.parse(ApiConstants.createUsuarioCategoriaEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "id_usuario": idUsuario,
            "id_categorias": categorias, // Lista de strings
          }),
        );

        if (response.statusCode == 200) {
          debugPrint("✅ Usuario-Categorías registrada:");
        } else {
          debugPrint(
              "⚠️ Error registrando usuario-categoría: ${response.body}");
        }
      } catch (e) {
        debugPrint(
            "⚠️ Error en conexión al registrar categorías: $e");
      }
  }
}
