import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
import 'registerclient3.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:nodo/core/constants/api_constants.dart';

class RegisterClient2 extends StatefulWidget {
  const RegisterClient2({super.key});

  @override
  State<RegisterClient2> createState() => _RegisterClient2State();
}

class _RegisterClient2State extends State<RegisterClient2> {
  late TextEditingController _telefonoController;
  late TextEditingController _emailController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _contrasenaController;
  late TextEditingController _confirmarController;

  @override
  void initState() {
    super.initState();
    _telefonoController = TextEditingController();
    _emailController = TextEditingController();
    _fechaNacimientoController = TextEditingController();
    _contrasenaController = TextEditingController();
    _confirmarController = TextEditingController();
  }

  @override
  void dispose() {
    _telefonoController.dispose();
    _emailController.dispose();
    _fechaNacimientoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.1;
    final fieldSpacing = screenHeight * 0.02;

    final userProvider = Provider.of<UserProvider>(context);
    final cedula = userProvider.cedula;

    final formContent = Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? horizontalPadding : 16),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CustomTextField(
                label: 'Número de teléfono',
                controller: _telefonoController,
                widthPercentage: 0.85,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Correo electrónico',
                controller: _emailController,
                widthPercentage: 0.85,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Fecha de nacimiento',
                controller: _fechaNacimientoController,
                widthPercentage: 0.85,
                isDate: true,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Contraseña',
                controller: _contrasenaController,
                widthPercentage: 0.85,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Confirmar contraseña',
                controller: _confirmarController,
                widthPercentage: 0.85,
              ),
            ],
          ),
        ),
      ),
    );

    return RegisterScaffold(
      title: 'Datos de acceso',
      stepIndex: 1,
      formContent: formContent,
      onNext: () async {
        final telefono = _telefonoController.text.trim();
        final email = _emailController.text.trim();
        final fechaNacimiento = _fechaNacimientoController.text.trim();
        final contrasena = _contrasenaController.text.trim();
        final confirmar = _confirmarController.text.trim();

        if ([telefono, email, fechaNacimiento, contrasena, confirmar].any((field) => field.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, completa todos los campos')),
          );
          return;
        }

        if (!RegExp(r'^\d{10}$').hasMatch(telefono)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El número de teléfono debe tener exactamente 10 dígitos')),
          );
          return;
        }

        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, ingresa un correo electrónico válido')),
          );
          return;
        }

        if (contrasena != confirmar) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Las contraseñas no coinciden')),
          );
          return;
        }

        final url = Uri.parse(ApiConstants.updateUsuarioEndpoint(cedula));

        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "telefono": telefono,
            "email": email,
            "fecha_nacimiento": fechaNacimiento,
            "contrasena": contrasena
          }),
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterClient3(),
            ),
          );
        } else {
          print("Error al actualizar: ${response.body}");
        }
      },
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double widthPercentage;
  final bool isDate;

  const _CustomTextField({
    required this.label,
    required this.controller,
    this.widthPercentage = 1.0,
    this.isDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneField = label.toLowerCase().contains('tel');

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * widthPercentage,
        child: TextField(
          controller: controller,
          keyboardType: isPhoneField
              ? TextInputType.number
              : (label.toLowerCase().contains('correo') ? TextInputType.emailAddress : TextInputType.text),
          inputFormatters: isPhoneField
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          readOnly: isDate,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          onTap: isDate
              ? () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.text = "${picked.toLocal()}".split(' ')[0];
                  }
                }
              : null,
        ),
      ),
    );
  }
}
