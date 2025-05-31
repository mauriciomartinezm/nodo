import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../../../providers/userprovider.dart';

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
      } else if (responseData is Map && responseData['message'] == 'No existen registros') {
        return [];
      }
      throw Exception('Formato de respuesta inesperado');
    }
    throw Exception('Error al cargar las publicaciones (${response.statusCode})');
  }

  Future<bool> deletePublicacion(String publicacionId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/deletePublicacion/$publicacionId'),
    );
    return response.statusCode == 200;
  }
}