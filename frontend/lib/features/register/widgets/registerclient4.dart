import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
//import 'package:nodo/features/trabajos/screens/trabajos2.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:nodo/providers/user_provider.dart';
import 'package:nodo/core/constants/api_constants.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterClient4 extends StatefulWidget {
  const RegisterClient4({super.key});

  @override
  State<RegisterClient4> createState() => _RegisterClient4State();
}

class _RegisterClient4State extends State<RegisterClient4> {
  bool _acceptedTerms = false;
  File? _imageFile;
  String? foto_perfil;
  bool _isLoading = false; // Nuevo estado para controlar la carga

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);

      setState(() {
        _imageFile = imageTemp;
      });
    }
  }

  Future<String> _subirImagenAFirebase(File imagen, String cedula) async {
    try {
      final nombreArchivo = '${cedula}_${path.basename(imagen.path)}';
      final ref =
          FirebaseStorage.instance.ref().child('perfiles/$nombreArchivo');

      final uploadTask = ref.putFile(imagen);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error al subir imagen a Firebase: $e");
      rethrow;
    }
  }

  Future<void> _enviarImagenAlBackend(String cedula, String urlFoto) async {
    final String apiUrl = ApiConstants.updateUsuarioEndpoint(cedula);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'foto_perfil': urlFoto,
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
    if (!_acceptedTerms || _isLoading) return; // Evitar múltiples clics

    setState(() => _isLoading = true); // Activar estado de carga

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cedula = userProvider.cedula;
    String urlImagen;

    try {
      if (_imageFile != null) {
        urlImagen = await _subirImagenAFirebase(_imageFile!, cedula);
      } else {
        urlImagen =
            "https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/perfiles%2FiconNodoBlue.png?alt=media&token=22b11580-c0ac-403e-89e3-5f09cc5cd25c";
      }

      await _enviarImagenAlBackend(cedula, urlImagen);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen_welcome', true);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hubo un problema al subir la imagen.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // Desactivar carga al finalizar
      }
    }
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
                              : const AssetImage(
                                      'assets/icons/iconNodoBlue.png')
                                  as ImageProvider,
                          backgroundColor:
                              Colors.grey.shade400.withOpacity(0.4),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit,
                                size: 18, color: Colors.orange.shade700),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 14),
                            children: [
                              const TextSpan(text: 'Acepto los '),
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Términos y Condiciones')),
                                    );
                                  },
                              ),
                              const TextSpan(text: ' y la '),
                              TextSpan(
                                text: 'Política de Privacidad',
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Política de Privacidad')),
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
                    onPressed:
                        _acceptedTerms && !_isLoading ? _onConfirmar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3557),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Aceptar y confirmar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
