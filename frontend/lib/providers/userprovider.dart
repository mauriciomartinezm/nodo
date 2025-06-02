import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

// Modelo del usuario
class Usuario {
  final String id;
  final String nombres;
  final String primerApellido;
  final String segundoApellido;
  final String email;
  final String telefono;
  final String fechaNacimiento;
  final String contrasena;
  final String fechaRegistro;
  final String fotoPerfil;
  final bool verificado;
  final String tipoUsuario;
  final dynamic categoria;
  final dynamic ubicacion;
  final dynamic descripcion;
  final dynamic calificacionPromedio;
  final dynamic trabajosCompletados;

  Usuario({
    required this.id,
    required this.nombres,
    required this.primerApellido,
    required this.segundoApellido,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.contrasena,
    required this.fechaRegistro,
    required this.fotoPerfil,
    required this.verificado,
    required this.tipoUsuario,
    required this.categoria,
    required this.ubicacion,
    required this.descripcion,
    this.calificacionPromedio,
    this.trabajosCompletados,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombres: json['nombres'],
      primerApellido: json['primer_apellido'],
      segundoApellido: json['segundo_apellido'],
      email: json['email'],
      telefono: json['telefono'],
      fechaNacimiento: json['fecha_nacimiento'],
      contrasena: json['contrasena'],
      fechaRegistro: json['fecha_registro'],
      fotoPerfil: json['foto_perfil'],
      verificado: json['verificado'],
      tipoUsuario: json['tipo_usuario'],
      categoria: json['categoria'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      calificacionPromedio: json['calificacion_promedio'],
      trabajosCompletados: json['trabajos_completados'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'primer_apellido': primerApellido,
      'segundo_apellido': segundoApellido,
      'email': email,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento,
      'contrasena': contrasena,
      'fecha_registro': fechaRegistro,
      'foto_perfil': fotoPerfil,
      'verificado': verificado,
      'tipo_usuario': tipoUsuario,
      'categoria': categoria,
      'ubicacion': ubicacion,
      'descripcion': descripcion,
      'calificacion_promedio': calificacionPromedio,
      'trabajos_completados': trabajosCompletados,
    };
  }
}

// Provider
class UserProvider with ChangeNotifier {
  Usuario? _usuario;
  bool _isLoading = false;
  String _message = "";

  String _cedula = '';
  bool _isWorker = false;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String get message => _message;

  String get cedula => _cedula;
  bool get isWorker => _isWorker;

  // Método para login
  Future<String> loginUsuario(String identificador, String contrasena) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identificador': identificador,
          'contrasena': contrasena,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuario = Usuario.fromJson(data['usuario']);
        _cedula = _usuario!.id;
        _isWorker = _usuario!.tipoUsuario == 'trabajador'; // Ajusta esto según tu base de datos
        _message = "Login exitoso";
      } else {
        _message = 'Credenciales inválidas: ${response.statusCode}';
      }
    } catch (e) {
      _message = 'Error al conectar con el servidor: $e';
    }

    _isLoading = false;
    notifyListeners();
    return _message;
  }
  
  void setCedula(String value) {
    _cedula = value;
    notifyListeners();
  }

  void setIsWorker(bool value) {
    _isWorker = value;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    _cedula = '';
    _isWorker = false;
    notifyListeners();
  }

  void updateUsuario(Usuario updatedUsuario) {
    _usuario = updatedUsuario;
    _cedula = updatedUsuario.id;
    _isWorker = updatedUsuario.tipoUsuario == 'trabajador';
    notifyListeners();
  }
}
