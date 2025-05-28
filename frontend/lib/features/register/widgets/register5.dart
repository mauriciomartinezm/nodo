import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/features/register/widgets/registerclient4.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';

class Register5 extends StatefulWidget {
  const Register5({super.key});

  @override
  State<Register5> createState() => _Register5State();
}

class _Register5State extends State<Register5> {
  final _habilidadController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _experienciaController = TextEditingController();

  @override
  void dispose() {
    _habilidadController.dispose();
    _ubicacionController.dispose();
    _experienciaController.dispose();
    super.dispose();
  }

  Future<void> _actualizarTrabajador(String idUsuario) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/createTrabajador');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "habilidad": _habilidadController.text.trim(),
          "ubicacion": _ubicacionController.text.trim(),
          "experiencia": _experienciaController.text.trim(),
          "idUsuario": idUsuario,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterClient4()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de red: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.1;
    final fieldSpacing = screenHeight * 0.02;

    final isWorker = Provider.of<UserProvider>(context).isWorker;
    final idUsuario = Provider.of<UserProvider>(context).cedula;

    return RegisterScaffold(
      title: 'Datos adicionalessssss',
      stepIndex: isWorker ? 3 : 4,
      formContent: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? horizontalPadding : 16,
          ),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Categoría o especialidad',
                controller: _habilidadController,
                widthPercentage: 0.85,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Ubicación o zona de servicio',
                controller: _ubicacionController,
                widthPercentage: 0.85,
              ),
              SizedBox(height: fieldSpacing),
              _CustomTextField(
                label: 'Descripción breve de los servicios que ofrece',
                controller: _experienciaController,
                widthPercentage: 0.85,
              ),
            ],
          ),
        ),
      ),
      onNext: () => _actualizarTrabajador(idUsuario),
      showNextButton: true,
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final double widthPercentage;
  final TextEditingController controller;

  const _CustomTextField({
    required this.label,
    required this.controller,
    this.widthPercentage = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * widthPercentage,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }
}
