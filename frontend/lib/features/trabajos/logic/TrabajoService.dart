// TODO Implement this library.import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:flutter/material.dart';

class TrabajoService {
  static Future<void> postularse(
      String publicacionId, String trabajadorId) async {
    print("💬Postulando...");
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.postularse),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'publicacionId': publicacionId,
          'trabajadorId': trabajadorId,
        }),
      );
      print("💬Respuesta del servidor: ");

      print(response.body);
      if (response.statusCode == 200) {
        // Postulación exitosa
        final responseData = jsonDecode(response.body);
        print('✅ Postulación exitosa: $responseData');
      } else {
        // Error en la postulación
        throw Exception('Error al postularse: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en postularse: $e');
      rethrow; // Re-lanzamos la excepción para manejarla en el UI
    }
  }

  static Future<void> deletePostulacion(String postulacionId) async {
    print("💬Eliminando postulación...");
    try {
      final response = await http.delete(
        Uri.parse(ApiConstants.deletePostulacionEndpoint(postulacionId)),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("💬Respuesta del servidor: ");

      print(response.body);
      if (response.statusCode == 200) {
        // Postulación exitosa
        final responseData = jsonDecode(response.body);
        print('✅ Postulación exitosa: $responseData');
      } else {
        // Error en la postulación
        throw Exception('Error al postularse: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en postularse: $e');
      rethrow; // Re-lanzamos la excepción para manejarla en el UI
    }
  }

  static Future<void> aceptarPostulacion(
      String idPostulacion, String nuevoEstado) async {
    final url =
        Uri.parse(ApiConstants.updatePostulacionEndpoint(idPostulacion));

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': nuevoEstado}),
    );

    if (response.statusCode == 200) {
      print("❕❕❕Status code 200");
    } else {
      print("❕❕❕Error");
    }
  }

  static Future<List<dynamic>> fetchPublicaciones() async {
    print("💬 Haciendo fetch a publicaciones");
    final response = await http.get(
      Uri.parse(ApiConstants.getPublicacionesEndpoint),
      headers: {'Content-Type': 'application/json'},
    );
    print("💬 PubLicaciones: ");
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar publicaciones: ${response.statusCode}');
    }
  }

  static Future<Map<String, String>> fetchNombresClientes(
      List publicaciones) async {
    print("💬 Haciendo fetch a usuarios");

    final Map<String, String> nombres = {};
    final clientIds =
        publicaciones.map((p) => p['id_cliente']).toSet().toList();
    for (final clientId in clientIds) {
      final response = await http.get(
        Uri.parse(ApiConstants.getClienteById(clientId)),
        headers: {'Content-Type': 'application/json'},
      );
      print("Usuario");
      print(response.body);
      if (response.statusCode == 200) {
        final clienteData = json.decode(response.body);
        print("Client Data");
        print(clienteData);
        nombres[clientId] = clienteData['nombres'];
      } else {
        nombres[clientId] = 'Cliente $clientId';
      }
    }
    print("Nombres: ");
    print(nombres);

    return nombres;
  }

  static Future<List<dynamic>> fetchPostulacionesPorUsuario(
      String userId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.getPostulacionesByUserId(userId)),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("💬 Postulaciones: ");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("✅ Se encontraron postulaciones");

      return jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      print("⚠️ No se encontraron postulaciones");
      return [];
    } else {
      throw Exception('Error al cargar postulaciones');
    }
  }

  static IconData getIconForCategory(String categoryId) {
    switch (categoryId) {
      case 'cat1':
        return Icons.plumbing;
      case 'cat2':
        return Icons.bug_report;
      case 'cat3':
        return Icons.electrical_services;
      case 'cat4':
        return Icons.computer;
      default:
        return Icons.work;
    }
  }

  static String formatTimeAgo(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Recién publicado';
    }
  }

  static Future<void> marcarComoTerminado(String postulacionId) async {
    print("❕❕❕❕Finalizando trabajo");

    final url = Uri.parse(ApiConstants.finalizarTrabajo);

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_postulacion': postulacionId, // Usa la variable real aquí
      }),
    );
    print("STATUS CODE: ");
    print(response.statusCode);
  }

  static Future<void> cancelarTrabajo(String? postulacionId) async {
    // Llama a tu API y cambia el estado del trabajo a "cancelado"
  }
}
