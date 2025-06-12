import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';

class PostulacionesScreen extends StatefulWidget {
  final String idPublicacion;
  const PostulacionesScreen({super.key, required this.idPublicacion});

  @override
  State<PostulacionesScreen> createState() => _PostulacionesScreenState();
}

class _PostulacionesScreenState extends State<PostulacionesScreen> {
  List<Map<String, dynamic>> postulaciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPostulaciones();
  }

  Future<void> fetchPostulaciones() async {
    print("Fetch postulaciones, id publicacion: ");
    print(widget.idPublicacion);
    final response = await http.get(
      Uri.parse(ApiConstants.getPostulacionesByPostId(widget.idPublicacion)),
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
          String nombreCategoria = "Sin categoría";
          final categoriaResponse = await http.get(
            Uri.parse(ApiConstants.getCategoriaEndpoint(user['id_categoria'])),
          );
          print("Usuario: ");
          print(user);
          if (categoriaResponse.statusCode == 200) {
            final categoria = jsonDecode(categoriaResponse.body);
            nombreCategoria = categoria['nombre_cat'] ?? "Sin categoría";
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
            'categoria': nombreCategoria,
          });
        }
      }

      setState(() {
        postulaciones = tempList;
        isLoading = false;
      });
    } else {
      // error al cargar
      setState(() {
        isLoading = false;
      });
    }
  }

  void aceptarPostulacion(String idPostulacion) {
    print('Aceptado: $idPostulacion');
  }

  void rechazarPostulacion(String idPostulacion) {
    print('Rechazado: $idPostulacion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postulaciones")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: postulaciones.length,
              itemBuilder: (context, index) {
                final post = postulaciones[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post['foto']),
                    ),
                    title: Text(post['nombre']),
                    subtitle: Text(post['correo']),
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
                          aceptarPostulacion(post['id_postulacion']);
                        } else if (value == 'rechazar') {
                          rechazarPostulacion(post['id_postulacion']);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'info', child: Text("Ver info")),
                        PopupMenuItem(value: 'aceptar', child: Text("Aceptar")),
                        PopupMenuItem(
                            value: 'rechazar', child: Text("Rechazar")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
