import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:flutter/material.dart';

class JobService {
  static Future<void> apply(
      String publicacionId, String trabajadorId) async {
    print("💬Postulando...");
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.apply),
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

  static Future<void> deleteApplication(String applicationId) async {
    print("💬Eliminando postulación...");
    try {
      final response = await http.delete(
        Uri.parse(ApiConstants.deleteApplication(applicationId)),
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

  static Future<void> acceptApplication(
      String applicationId, String newStatus) async {
    final url =
        Uri.parse(ApiConstants.updateApplication(applicationId));

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': newStatus}),
    );

    if (response.statusCode == 200) {
      print("❕❕❕Status code 200");
    } else {
      print("❕❕❕Error");
    }
  }

  static Future<List<dynamic>> fetchPosts() async {
    print("💬 Haciendo fetch a publicaciones");
    final response = await http.get(
      Uri.parse(ApiConstants.getPosts),
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

  static Future<Map<String, String>> fetchClientNames(
      List posts) async {
    print("💬 Haciendo fetch a usuarios");

    final Map<String, String> names = {};
    final clientIds =
        posts.map((p) => p['id_cliente']).toSet().toList();
    for (final clientId in clientIds) {
      final response = await http.get(
        Uri.parse(ApiConstants.getUser(clientId)),
        headers: {'Content-Type': 'application/json'},
      );
      print("Usuario");
      print(response.body);
      if (response.statusCode == 200) {
        final clientData = json.decode(response.body);
        print("Client Data");
        print(clientData);
        names[clientId] = clientData['nombres'];
      } else {
        names[clientId] = 'Cliente $clientId';
      }
    }
    print("Nombres: ");
    print(names);

    return names;
  }

  static Future<List<dynamic>> fetchApplicationsByUser(
      String userId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.getApplicationsByUserId(userId)),
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

  static Future<void> markAsFinished(String applicationId) async {
    print("❕❕❕❕Finalizando trabajo");

    final url = Uri.parse(ApiConstants.finishJob);

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_postulacion': applicationId, // Usa la variable real aquí
      }),
    );
    print("STATUS CODE: ");
    print(response.statusCode);
  }

  static Future<void> cancelJob(String? applicationId) async {
    // Llama a tu API y cambia el estado del trabajo a "cancelado"
  }
}
