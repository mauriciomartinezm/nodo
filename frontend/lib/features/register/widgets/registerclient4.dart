import 'dart:io';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
//import 'package:nodo/features/trabajos/screens/trabajos2.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:nodo/core/constants/api_constants.dart';

class RegisterClient4 extends StatefulWidget {
  const RegisterClient4({super.key});

  @override
  State<RegisterClient4> createState() => _RegisterClient4State();
}

class _RegisterClient4State extends State<RegisterClient4> {
  bool _acceptedTerms = false;
  File? _imageFile;
  String? foto_perfil;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      final bytes = await imageTemp.readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _imageFile = imageTemp;
        foto_perfil = base64Image;
      });

      print("Imagen en base64: $foto_perfil");
    }
  }

  Future<void> _cargarImagenPorDefecto() async {
    final byteData = await rootBundle.load('assets/icons/iconNodoBlue.png');
    final base64Image = base64Encode(byteData.buffer.asUint8List());
    foto_perfil = base64Image;
    print("Imagen por defecto en base64 cargada.");
  }

  Future<void> _enviarImagenAlBackend(String cedula) async {
    final String apiUrl = ApiConstants.updateUsuarioEndpoint(cedula);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'foto_perfil': foto_perfil,
        }),
      );

      if (response.statusCode == 200) {
        print('Imagen actualizada correctamente');
      } else {
        print('Error al actualizar imagen: ${response.body}');
      }
    } catch (e) {
      print('Excepción al enviar imagen: $e');
    }
  }

  void _onConfirmar() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cedula = userProvider.cedula;

    if (foto_perfil == null) {
      await _cargarImagenPorDefecto();
    }

    print("Cédula enviada: $cedula");

    await _enviarImagenAlBackend(cedula);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isWorker = Provider.of<UserProvider>(context).isWorker;

    return RegisterScaffold(
      title: 'Personalización y confirmación',
      stepIndex: isWorker ? 4 : 3, // 👈
      formContent: SizedBox(
        height: screenHeight * 0.75,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight * 0.75),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const Text(
                    'Personaliza tu cuenta con una imagen. Esto ayudará a otros usuarios a reconocerte, '
                    'pero puedes omitir este paso si lo deseas.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage('assets/icons/iconNodoBlue.png') as ImageProvider,
                          backgroundColor: Colors.grey.shade400.withOpacity(0.4),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 18, color: Colors.orange.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                            children: [
                              const TextSpan(text: 'Acepto los '),
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Términos y Condiciones')),
                                    );
                                  },
                              ),
                              const TextSpan(text: ' y la '),
                              TextSpan(
                                text: 'Política de Privacidad',
                                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Política de Privacidad')),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _acceptedTerms ? _onConfirmar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3557),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Aceptar y confirmar',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      onNext: () {}, // vacío porque no usamos botón siguiente aquí
      showNextButton: false, // ocultamos botón siguiente
    );
  }
}
