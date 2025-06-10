// TODO Implement this library.import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:flutter/material.dart';

class TrabajoService {
  static Future<void> postularse(
      String publicacionId, String trabajadorId) async {
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

      if (response.statusCode == 200) {
        // Postulación exitosa
        final responseData = jsonDecode(response.body);
        print('Postulación exitosa: $responseData');
      } else {
        // Error en la postulación
        throw Exception('Error al postularse: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en postularse: $e');
      rethrow; // Re-lanzamos la excepción para manejarla en el UI
    }
  }

  static Future<List<dynamic>> fetchPublicaciones() async {
    final response = await http.get(
      Uri.parse(ApiConstants.getPublicacionesEndpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar publicaciones: ${response.statusCode}');
    }
  }

  static Future<Map<String, String>> fetchNombresClientes(
      List publicaciones) async {
    final Map<String, String> nombres = {};
    final clientIds =
        publicaciones.map((p) => p['id_cliente']).toSet().toList();
    for (final clientId in clientIds) {
      final response = await http.get(
        Uri.parse(ApiConstants.getClienteById(clientId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final clienteData = json.decode(response.body);
        nombres[clientId] = clienteData[0]['nombres'];
      } else {
        nombres[clientId] = 'Cliente $clientId';
      }
    }

    return nombres;
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
}
