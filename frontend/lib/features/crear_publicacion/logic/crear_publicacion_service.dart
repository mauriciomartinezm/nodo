import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';

class CrearPublicacionService {
  Future<List<Map<String, String>>> obtenerCategorias() async {
    final response = await http.get(Uri.parse(ApiConstants.getCategoriasEndpoint));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Map<String, String>>((categoria) {
        return {
          'id': categoria['id'].toString(),
          'nombre': categoria['nombre_cat'].toString(),
          'descripcion': categoria['descripcion'].toString()
        };
      }).toList();
    }
    throw Exception('Error al obtener categorías: ${response.statusCode}');
  }

  Future<bool> crearPublicacion(Map<String, dynamic> datosPublicacion) async {
    final response = await http.post(
      Uri.parse(ApiConstants.createPublicacionEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(datosPublicacion),
    );

    print(response.body);
    
    return response.statusCode == 200 || response.statusCode == 201;
  }
}