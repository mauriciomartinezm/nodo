import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';

class ChatService {
  static Future<String> getOrCreateConversation(String applicationId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.getOrCreateConversation(applicationId)),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['id'] as String;
    }
    throw Exception('Error al obtener la conversación (${response.statusCode})');
  }

  static Future<List<Map<String, dynamic>>> getMessages(
      String conversationId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.getMessages(conversationId)),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    }
    throw Exception('Error al cargar mensajes (${response.statusCode})');
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sendMessage),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Error al enviar el mensaje (${response.statusCode})');
  }
}
