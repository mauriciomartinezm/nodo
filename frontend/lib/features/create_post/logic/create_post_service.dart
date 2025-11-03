import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_constants.dart';

class CrearPublicacionService {

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