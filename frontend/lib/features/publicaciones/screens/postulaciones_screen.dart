import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nodo/core/constants/api_constants.dart';
import 'package:nodo/features/chat/screens/Chat1.dart';

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
    actualizarEstadoPostulacion(idPostulacion, "aceptado");
  }

  void rechazarPostulacion(String idPostulacion) {
    actualizarEstadoPostulacion(idPostulacion, "rechazado");
  }

  void irAlChat(String idTrabajador, String nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
            //receptorId: idTrabajador,
            //receptorNombre: nombre,
            ),
      ),
    );
  }

  Future<void> actualizarEstadoPostulacion(
      String idPostulacion, String nuevoEstado) async {
    final url =
        Uri.parse(ApiConstants.updatePostulacionEndpoint(idPostulacion));

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': nuevoEstado}),
    );

    if (response.statusCode == 200) {
      // Opcional: mostrar snackbar o recargar datos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a "$nuevoEstado"')),
      );
      // Vuelve a cargar la lista
      fetchPostulaciones();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la postulación')),
      );
    }
  }

  bool yaHayUnaAceptada() {
    return postulaciones.any((p) => p['estado'] == 'aceptado');
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
                          aceptarPostulacion(post['id_postulacion']);
                        } else if (value == 'rechazar') {
                          rechazarPostulacion(post['id_postulacion']);
                        } else if (value == 'chat') {
                          irAlChat(post['id_trabajador'], post['nombre']);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'info', child: Text("Ver info")),
                        PopupMenuItem(
                          value: 'aceptar',
                          enabled: post['estado'] == 'pendiente' &&
                              !yaHayUnaAceptada(),
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
