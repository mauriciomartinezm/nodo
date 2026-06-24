import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:nodo/features/chat/screens/Chat1.dart';

class ApplicationsScreen extends StatefulWidget {
  final String postId;
  const ApplicationsScreen({super.key, required this.postId});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  List<Map<String, dynamic>> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    print("Fetch postulaciones, id publicacion: ");
    print(widget.postId);
    final response = await http.get(
      Uri.parse(ApiConstants.getApplicationsByPostId(widget.postId)),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> tempList = [];

      for (var post in data) {
        final userResponse = await http.get(
          Uri.parse(ApiConstants.getUser(post['id_trabajador'])),
        );

        if (userResponse.statusCode == 200) {
          final user = jsonDecode(userResponse.body);

          // Obtener el nombre de la categoría
          String categoryName = "Sin categoría";
          final categoryResponse = await http.get(
            Uri.parse(ApiConstants.getCategory(user['id_categoria'])),
          );
          print("Usuario: ");
          print(user);
          if (categoryResponse.statusCode == 200) {
            final category = jsonDecode(categoryResponse.body);
            categoryName = category['nombre_cat'] ?? "Sin categoría";
          }
          tempList.add({
            'id_postulacion': post['id'],
            'id_trabajador': user['id'],
            'estado': post['estado'], // necesario?
            'ubicacion': user['ubicacion'] ?? "Sin ubicación",
            'telefono': user['telefono'] ?? "Sin teléfono",
            'nombre': '${user['nombres']} ${user['primer_apellido']}',
            'correo': user['email'],
            'foto': user['foto_perfil'],
            'descripcion': user['descripcion'],
            'categoria': categoryName,
          });
        }
      }

      setState(() {
        applications = tempList;
        isLoading = false;
      });
    } else {
      // error al cargar
      setState(() {
        isLoading = false;
      });
    }
  }

  void acceptApplication(String applicationId) {
    updateApplicationStatus(applicationId, "considerado");

  }

  void rejectApplication(String applicationId) {
    updateApplicationStatus(applicationId, "rechazado");
  }

  void goToChat(String workerId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
            //receptorId: workerId,
            //receptorNombre: name,
            ),
      ),
    );
  }

  Future<void> updateApplicationStatus(
      String applicationId, String newStatus) async {
    final url =
        Uri.parse(ApiConstants.updateApplication(applicationId));

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': newStatus}),
    );

    if (response.statusCode == 200) {
      // Opcional: mostrar snackbar o recargar datos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a "$newStatus"')),
      );
      // Vuelve a cargar la lista
      fetchApplications();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la postulación')),
      );
    }
  }

  bool hasAcceptedApplication() {
    return applications.any((p) => p['estado'] == 'aceptado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postulaciones")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final post = applications[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post['foto']),
                    ),
                    title: Text(post['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['correo']),
                        Text("Estado: ${post['estado']}"),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'info') {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(post['nombre']),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Correo: ${post['correo']}"),
                                  const SizedBox(height: 8),
                                  Text("Ubicación: ${post['ubicacion']}"),
                                  const SizedBox(height: 8),
                                  Text("Categoría: ${post['categoria']}"),
                                  const SizedBox(height: 8),
                                  Text("Descripción:"),
                                  Text(
                                      post['descripcion'] ?? 'Sin descripción'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cerrar"),
                                ),
                              ],
                            ),
                          );
                        } else if (value == 'aceptar') {
                          acceptApplication(post['id_postulacion']);
                        } else if (value == 'rechazar') {
                          rejectApplication(post['id_postulacion']);
                        } else if (value == 'chat') {
                          goToChat(post['id_trabajador'], post['nombre']);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'info', child: Text("Ver info")),
                        PopupMenuItem(
                          value: 'aceptar',
                          enabled: post['estado'] == 'pendiente' &&
                              !hasAcceptedApplication(),
                          child: Text("Aceptar"),
                        ),
                        PopupMenuItem(
                          value: 'rechazar',
                          enabled: post['estado'] == 'pendiente',
                          child: Text("Rechazar"),
                        ),
                        PopupMenuItem(value: 'chat', child: Text("Chatear")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
