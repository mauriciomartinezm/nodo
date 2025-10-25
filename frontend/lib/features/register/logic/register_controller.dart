import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:nodo/providers/user_provider.dart';
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
  }) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      final cedula = idController.text.trim();
      final nombres = nameController.text.trim();
      final primerApellido = lastName1Controller.text.trim();
      final segundoApellido = lastName2Controller.text.trim();
      final fecha_nacimiento = dateController.text.trim();
      final contrasena = passwordController.text.trim();
      final confirmacionContrasena = confirmPasswordController.text.trim();
      final telefono = phoneController.text.trim();
      final ubicacion = locationController.text.trim();
      final descripcion = descriptionController.text.trim();
      final categorias = selectedCategories;
      
      // Validar que las contraseñas coincidan

      if (contrasena != confirmacionContrasena) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden.')),
        );
        _setLoading(false);
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final tipoUsuario = selectedUserType ?? 
          (userProvider.isWorker ? "trabajador" : "cliente");

      final url = Uri.parse(ApiConstants.createUsuarioEndpoint);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": cedula,
          "nombres": nombres,
          "primer_apellido": primerApellido,
          "segundo_apellido": segundoApellido,
          "fecha_registro": DateTime.now().toUtc().toIso8601String(),
          "verificado": false,
          "tipo_usuario": tipoUsuario,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Usuario agregado: ${response.body}");
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
}
