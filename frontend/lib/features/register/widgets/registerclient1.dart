import 'package:flutter/material.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
import 'package:nodo/features/register/widgets/registerclient2.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterClient1 extends StatefulWidget {
  const RegisterClient1({super.key});

  @override
  State<RegisterClient1> createState() => _RegisterClient1State();
}

class _RegisterClient1State extends State<RegisterClient1> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.1;
    final fieldSpacing = screenHeight * 0.02;

    // Contenido del formulario, sin ProgressDots
    final formContent = Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? horizontalPadding : 16,
        ),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ValidatedTextField(
                label: 'Nombre(s)',
                controller: _nombreController,
                widthPercentage: 0.85,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$").hasMatch(value)) {
                    return 'Solo se permiten letras';
                  }
                  return null;
                },
              ),
              SizedBox(height: fieldSpacing),
              _ValidatedTextField(
                label: 'Apellidos',
                controller: _apellidoController,
                widthPercentage: 0.85,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$").hasMatch(value)) {
                    return 'Solo se permiten letras';
                  }
                  return null;
                },
              ),
              SizedBox(height: fieldSpacing),
              _ValidatedTextField(
                label: 'Cédula',
                controller: _cedulaController,
                widthPercentage: 0.85,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (!RegExp(r"^\d{1,10}$").hasMatch(value)) {
                    return 'Debe contener solo números (máx. 10 dígitos)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );

    return RegisterScaffold(
      title: 'Información Básica',
      stepIndex: 0,
      formContent: formContent,
      onNext: () async {
        if (_formKey.currentState!.validate()) {
          final nombreCompleto =
              "${_nombreController.text.trim()} ${_apellidoController.text.trim()}";
          final cedula = _cedulaController.text.trim();

          Provider.of<UserProvider>(context, listen: false).setCedula(cedula);

          final url = Uri.parse("http://192.168.1.92:3000/api/createCliente");

          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"id": cedula, "nombre": nombreCompleto}),
          );

          if (response.statusCode == 200) {
            print("Agregado: ${response.body}");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterClient2()),
            );
          } else {
            print("Error al registrar: ${response.body}");
          }
        }
      },
    );
  }
}

class _ValidatedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double widthPercentage;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _ValidatedTextField({
    required this.label,
    required this.controller,
    this.widthPercentage = 1.0,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * widthPercentage,
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
