import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _dniController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final dni = _dniController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || dni.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Todos los campos son obligatorios.');
      return;
    }
    if (password.length < 6) {
      _showSnack('La contraseña debe tener al menos 6 caracteres.');
      return;
    }
    if (password != confirm) {
      _showSnack('Las contraseñas no coinciden.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'dni': dni, 'newPassword': password}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        _showSnack('Contraseña actualizada correctamente.');
        Navigator.of(context).pop();
      } else {
        final body = jsonDecode(response.body);
        _showSnack(body['message'] ?? 'Error al actualizar la contraseña.');
      }
    } catch (_) {
      if (!mounted) return;
      _showSnack('No se pudo conectar con el servidor.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180.h,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    Icon(Icons.lock_reset, size: 48.h, color: AppColors.white),
                    SizedBox(height: 12.h),
                    Text(
                      'Restablecer contraseña',
                      style: AppTypography.title.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingresa tu correo y cédula para verificar tu identidad, luego escribe tu nueva contraseña.',
                    style: AppTypography.body.copyWith(color: AppColors.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  _buildField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 14.h),
                  _buildField(
                    controller: _dniController,
                    label: 'Cédula (DNI)',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 14.h),
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'Nueva contraseña',
                    obscure: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  SizedBox(height: 14.h),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar contraseña',
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  SizedBox(height: 32.h),
                  CustomElevatedButton(
                    text: 'Restablecer contraseña',
                    loading: _isLoading,
                    onPressed: _isLoading ? null : _submit,
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Volver al inicio de sesión',
                        style: AppTypography.body.copyWith(color: AppColors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
