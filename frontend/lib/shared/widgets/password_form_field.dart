import 'package:flutter/material.dart';

/// TextFormField de contraseña. La visibilidad (obscureText) se controla
/// desde afuera, para poder compartir un solo botón de ojo entre varios
/// campos (por ejemplo, "Contraseña" y "Confirma tu contraseña").
class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  /// Si es null, el campo no muestra su propio ícono de ojo.
  final VoidCallback? onToggleVisibility;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.validator,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: onToggleVisibility == null
            ? null
            : IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggleVisibility,
              ),
      ),
      validator: validator,
    );
  }
}
