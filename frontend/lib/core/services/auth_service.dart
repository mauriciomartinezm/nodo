import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants/api_constants.dart';
import 'package:nodo/models/user.dart';

class AuthService {
  Future<User?> login(String identificador, String contrasena) async {
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
        final usuario = User.fromJson(data['usuario']);
        await _guardarTokenFCM(usuario.id);
        return usuario;
      } else {
        throw Exception('Credenciales inválidas');
      }
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  Future<void> logout(String userId) async {
    try {
      await _deleteTokenFCM(userId);
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  Future<void> _guardarTokenFCM(String userId) async {
    final nuevoToken = await FirebaseMessaging.instance.getToken();
    if (nuevoToken == null) return;

    final prefs = await SharedPreferences.getInstance();
    final tokenGuardado = prefs.getString('fcm_token');

    if (tokenGuardado == nuevoToken) return;

    final response = await http.post(
      Uri.parse(ApiConstants.saveToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': userId, 'token': nuevoToken}),
    );

    if (response.statusCode == 200) {
      await prefs.setString('fcm_token', nuevoToken);
    } else {
      print('Error al guardar token FCM: ${response.body}');
    }
  }

  Future<void> _deleteTokenFCM(String userId) async {
    await FirebaseMessaging.instance.deleteToken();
    await http.put(
      Uri.parse(ApiConstants.deleteToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': userId}),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
  }
}
