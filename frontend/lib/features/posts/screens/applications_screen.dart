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
    final response = await http.get(
      Uri.parse(ApiConstants.getApplicationsByPostId(widget.postId)),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> tempList = [];

      for (var application in data) {
        final userResponse = await http.get(
          Uri.parse(ApiConstants.getUser(application['workerId'])),
        );

        if (userResponse.statusCode == 200) {
          final user = jsonDecode(userResponse.body);

          final workerCategories = (user['worker']?['workerCategories'] as List?) ?? [];
          final categoryName = workerCategories.isNotEmpty
              ? workerCategories.map((wc) => wc['generalCategory']?['name']).join(', ')
              : "Sin categoría";

          tempList.add({
            'applicationId': application['id'],
            'workerId': user['id'],
            'status': application['status'],
            'location': user['location'] ?? "Sin ubicación",
            'phone': user['phone'] ?? "Sin teléfono",
            'name': '${user['firstName']} ${user['lastName']}',
            'email': user['email'],
            'photo': user['profilePhoto'],
            'description': user['worker']?['description'],
            'category': categoryName,
          });
        }
      }

      setState(() {
        applications = tempList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void acceptApplication(String applicationId) {
    updateApplicationStatus(applicationId, "accepted");
  }

  void rejectApplication(String applicationId) {
    updateApplicationStatus(applicationId, "rejected");
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
    final url = Uri.parse(ApiConstants.updateApplication(applicationId));

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': newStatus}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a "$newStatus"')),
      );
      fetchApplications();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la postulación')),
      );
    }
  }

  bool hasAcceptedApplication() {
    return applications.any((p) => p['status'] == 'accepted');
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
                      backgroundImage: NetworkImage(post['photo']),
                    ),
                    title: Text(post['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['email']),
                        Text("Estado: ${post['status']}"),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'info') {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(post['name']),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Correo: ${post['email']}"),
                                  const SizedBox(height: 8),
                                  Text("Ubicación: ${post['location']}"),
                                  const SizedBox(height: 8),
                                  Text("Categoría: ${post['category']}"),
                                  const SizedBox(height: 8),
                                  Text("Descripción:"),
                                  Text(post['description'] ?? 'Sin descripción'),
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
                          acceptApplication(post['applicationId']);
                        } else if (value == 'rechazar') {
                          rejectApplication(post['applicationId']);
                        } else if (value == 'chat') {
                          goToChat(post['workerId'], post['name']);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'info', child: Text("Ver info")),
                        PopupMenuItem(
                          value: 'aceptar',
                          enabled: post['status'] == 'pending' &&
                              !hasAcceptedApplication(),
                          child: Text("Aceptar"),
                        ),
                        PopupMenuItem(
                          value: 'rechazar',
                          enabled: post['status'] == 'pending',
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
