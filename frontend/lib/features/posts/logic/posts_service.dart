import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../../../shared/providers/user_provider.dart';

class Application {
  final String id;
  final String idTrabajador;
  final String nombre;
  final String estado;

  Application({
    required this.id,
    required this.idTrabajador,
    required this.nombre,
    required this.estado,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      idTrabajador: json['workerId'],
      nombre: json['nombre'] ?? 'Sin nombre',
      estado: json['status'],
    );
  }
}

class PostsService {
  final UserProvider userProvider;

  PostsService(this.userProvider);

  Future<List<dynamic>> getPostsByUserId() async {
    final userId = userProvider.user!.id;
    final response = await http.get(
      Uri.parse(ApiConstants.getPostsByUserId(userId)),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is List) {
        return responseData;
      } else if (responseData is Map &&
          (responseData['message'] == 'No existen registros' ||
              responseData['message'] == 'No records found')) {
        return [];
      }
      throw Exception('Formato de respuesta inesperado');
    }
    throw Exception(
        'Error al cargar las publicaciones (${response.statusCode})');
  }

  Future<bool> deletePost(String postId) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.deletePost(postId)),
    );
    return response.statusCode == 200;
  }

  Future<List<Application>> getApplications(String postId) async {
    final url = Uri.parse(ApiConstants.getApplicationsByPostId(postId));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = List<Map<String, dynamic>>.from(data);
      return list.map((json) => Application.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> updatePost(
      String postId, Map<String, dynamic> data) async {
    final url = Uri.parse(ApiConstants.updatePost(postId));

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
  Future<bool> updateApplication(
      String applicationId, Map<String, dynamic> data) async {
    final url = Uri.parse(ApiConstants.updateApplication(applicationId));

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
