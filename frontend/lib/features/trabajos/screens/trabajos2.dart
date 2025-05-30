import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nodo/features/trabajos/screens/trabajos3.dart';
import 'package:nodo/features/trabajos/screens/trabajos6.dart';

class TrabajosScreen2 extends StatefulWidget {
  const TrabajosScreen2({Key? key}) : super(key: key);

  @override
  _TrabajosScreen2State createState() => _TrabajosScreen2State();
}

class _TrabajosScreen2State extends State<TrabajosScreen2> {
  List<dynamic> _publicaciones = [];
  Map<String, String> _nombresClientes =
      {}; // Mapa para almacenar nombres de clientes
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPublicaciones();
  }

  Future<void> _fetchPublicaciones() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/getPublicaciones/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final publicaciones = json.decode(response.body);

        // Obtener nombres de clientes para todas las publicaciones
        await _fetchNombresClientes(publicaciones);

        setState(() {
          _publicaciones = publicaciones;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error al cargar las publicaciones: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error de conexión: $e';
      });
    }
  }

  Future<void> _fetchNombresClientes(List<dynamic> publicaciones) async {
    try {
      // Obtener todos los IDs de clientes únicos
      final clientIds =
          publicaciones.map((p) => p['id_cliente']).toSet().toList();

      // Hacer peticiones para cada cliente
      for (final clientId in clientIds) {
        
        final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/api/getCliente/$clientId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final clienteData = json.decode(response.body);
          
          setState(() {
              _nombresClientes[clientId] = clienteData[0]['nombre'];
            });
          ///_nombresClientes[clientId] = clienteData[clientId]['nombre']; // Valor por defecto

          //if (clienteData is Map<String, dynamic>) {
          //  setState(() {
          //    _nombresClientes[clientId] = clienteData[clientId]['nombre'];
          //  });
          //} else {
          //  setState(() {
          //     _nombresClientes[clientId] = clienteData[clientId]['nombre'];
          //  });
          //}
        } else {
          setState(() {
            _nombresClientes[clientId] = 'Cliente $clientId';
          });
        }
      }
    } catch (e) {
      print('Error al obtener nombres de clientes: $e');
    }
  }

  IconData _getIconForCategory(String categoryId) {
    // Mapeo de categorías a iconos
    switch (categoryId) {
      case 'cat1': // Plomería
        return Icons.plumbing;
      case 'cat2': // Control de plagas
        return Icons.bug_report;
      case 'cat3': // Electricidad
        return Icons.electrical_services;
      case 'cat4': // Computadores
        return Icons.computer;
      default:
        return Icons.work;
    }
  }

  String _formatTimeAgo(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Recién publicado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Trabajos',
            style: TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF003366),
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorColor: Color(0xFF003366),
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'Disponibles'),
              Tab(text: 'Mis postulaciones'),
              Tab(text: 'Mis trabajos'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.orange),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FiltroCategoriaScreen(),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildJobList(context),
            const Center(child: Text("Mis postulaciones")),
            const Center(child: Text("Mis trabajos")),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_publicaciones.isEmpty) {
      return const Center(child: Text('No hay publicaciones disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: _publicaciones.length,
      itemBuilder: (context, index) {
        final publicacion = _publicaciones[index];
        final nombreCliente = _nombresClientes[publicacion['id_cliente']] ?? 'Cargando nombre...';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getIconForCategory(publicacion['id_categoria']),
                  size: 35,
                  color: const Color(0xFF003366),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${publicacion['titulo']}: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: publicacion['descripcion_necesidad'],
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${publicacion['presupuesto']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        publicacion['ubicacion'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "${_formatTimeAgo(publicacion['fecha_publicacion'])} · ${publicacion['estado']}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) => DraggableScrollableSheet(
                            initialChildSize: 0.75,
                            minChildSize: 0.4,
                            maxChildSize: 0.95,
                            expand: false,
                            builder:
                                (_, scrollController) => DetalleTrabajoScreen(
                                  job: {
                                    "title": publicacion['titulo'],
                                    "description":
                                        publicacion['descripcion_necesidad'],
                                    "price": "\$${publicacion['presupuesto']}",
                                    "location": "${publicacion['ubicacion']}",
                                    "user":
                                        "Nombre del cliente: $nombreCliente", //
                                    "time":
                                        "${_formatTimeAgo(publicacion['fecha_publicacion'])} · ${publicacion['estado']}",
                                    "image": _getIconForCategory(
                                      publicacion['id_categoria'],
                                    ),
                                    "images": [
                                      'assets/icons/img_buttom_one.png',
                                      'assets/icons/img_buttom_two.png',
                                      'assets/icons/img_screen_one.png',
                                      'assets/icons/img_screen_two.png',
                                    ],
                                  },
                                  scrollController: scrollController,
                                ),
                          ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Ver detalles"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
