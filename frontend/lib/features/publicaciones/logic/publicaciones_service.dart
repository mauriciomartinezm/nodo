import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../../../providers/userprovider.dart';

class Postulacion {
  final String id;
  final String idTrabajador;
  final String nombre;
  final String estado;

  Postulacion({
    required this.id,
    required this.idTrabajador,
    required this.nombre,
    required this.estado,
  });

  factory Postulacion.fromJson(Map<String, dynamic> json) {
    return Postulacion(
      id: json['id'],
      idTrabajador: json['id_trabajador'],
      nombre: json['nombre'] ?? 'Sin nombre',
      estado: json['estado'],
    );
  }
}

class PublicacionesService {
  final UserProvider userProvider;

  PublicacionesService(this.userProvider);

  Future<List<dynamic>> getPublicacionesByUserId() async {
    final usuarioId = userProvider.usuario!.id;
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/getPublicacionesByUserId/$usuarioId'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is List) {
        return responseData;
      } else if (responseData is Map &&
          responseData['message'] == 'No existen registros') {
        return [];
      }
      throw Exception('Formato de respuesta inesperado');
    }
    throw Exception(
        'Error al cargar las publicaciones (${response.statusCode})');
  }

  Future<bool> deletePublicacion(String publicacionId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/deletePublicacion/$publicacionId'),
    );
    return response.statusCode == 200;
  }

  Future<List<Postulacion>> obtenerPostulaciones(String idPublicacion) async {
    final url = Uri.parse(
        "${ApiConstants.baseUrl}/getPostulacionesByPostId/$idPublicacion");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lista = List<Map<String, dynamic>>.from(data);
      return lista.map((json) => Postulacion.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> updatePublicacion(
      String idPublicacion, Map<String, dynamic> data) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/updatePublicacion/$idPublicacion');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar publicación: ${response.body}');
      return false;
    }
  }
  Future<bool> updatePostulacion(
      String idPostulacion, Map<String, dynamic> data) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/updatePostulacion/$idPostulacion');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar publicación: ${response.body}');
      return false;
    }
  }
}
