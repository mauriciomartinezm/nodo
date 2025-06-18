import 'package:flutter/material.dart';

import 'package:nodo/features/trabajos/screens/trabajos3.dart';
import 'package:nodo/features/trabajos/screens/trabajos6.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService.dart'; // Asegúrate de importar aquí
import 'package:nodo/features/trabajos/widgets/joblist.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:provider/provider.dart';

class TrabajosScreen2 extends StatefulWidget {
  const TrabajosScreen2({super.key});

  @override
  _TrabajosScreen2State createState() => _TrabajosScreen2State();
}

class _TrabajosScreen2State extends State<TrabajosScreen2> {
  List<dynamic> _publicaciones = [];
  Map<String, String> _nombresClientes = {};
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _postulaciones = [];
  List<dynamic> _postulacionesPendientes = [];
  List<dynamic> _postulacionesAceptadas = [];
  List<dynamic> _postulacionesRechazadas = [];

  bool _isLoadingPostulaciones = true;
  String _errorMessagePostulaciones = '';
  String _trabajadorId = '';
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await _loadData();
    await _loadPostulaciones();
  }

  Future<void> _loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentId = userProvider.usuario?.id; // o userProvider.cedula
    try {
      final publicaciones = await TrabajoService.fetchPublicaciones();
      final nombres = await TrabajoService.fetchNombresClientes(publicaciones);

      setState(() {
        _publicaciones = publicaciones;
        _nombresClientes = nombres;
        _isLoading = false;
        _trabajadorId = currentId!;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _loadPostulaciones() async {
    print("💬 Cargando Postulaciones");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentId = userProvider.usuario?.id;
    if (currentId == null) return;

    try {
      final postulaciones =
          await TrabajoService.fetchPostulacionesPorUsuario(currentId);
      print(postulaciones);

      // Filtrar por estado
      final pendientes =
          postulaciones.where((p) => p['estado'] == 'pendiente').toList();
      final aceptadas =
          postulaciones.where((p) => p['estado'] == 'aceptado').toList();
      final rechazadas =
          postulaciones.where((p) => p['estado'] == 'rechazado').toList();

      setState(() {
        _postulaciones = postulaciones;
        _postulacionesPendientes = pendientes;
        _postulacionesAceptadas = aceptadas;
        _postulacionesRechazadas = rechazadas;
        _isLoadingPostulaciones = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPostulaciones = false;
        _errorMessagePostulaciones = 'Error: $e';
      });
    }
  }

  void _mostrarDetalleTrabajo(
      dynamic publicacion, String nombreCliente, bool desdePostulaciones) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => DetalleTrabajoScreen(
          job: {
            "id": publicacion['id'],
            "title": publicacion['titulo'],
            "description": publicacion['descripcion_necesidad'],
            "price": "\$${publicacion['presupuesto']}",
            "location": "${publicacion['ubicacion']}",
            "user": "Nombre del cliente: $nombreCliente",
            "time":
                "${TrabajoService.formatTimeAgo(publicacion['fecha_publicacion'])} · ${publicacion['estado']}",
            "image":
                TrabajoService.getIconForCategory(publicacion['id_categoria']),
            "images":
                _parseImages(publicacion['fotos']), // Usa las imágenes reales
          },
          scrollController: scrollController,
          desdePostulaciones: desdePostulaciones,
        ),
      ),
    );
  }

  void _mostrarDetalleDesdePostulacion(dynamic publicacion, String _) {
    final idCliente = publicacion['id_cliente'];
    print("nombres de clientes");
    print(_nombresClientes);
    print(idCliente);

    final nombreCliente = _nombresClientes[idCliente.toString()] ?? 'Cliente';

    print(nombreCliente);
    _mostrarDetalleTrabajo(publicacion, nombreCliente, true);
  }

  List<String> _parseImages(String fotosString) {
    print("fotos string");
    print(fotosString);
    if (fotosString.isEmpty || fotosString.toLowerCase() == 'sin fotos') {
      return ['assets/images/diomedes_joven.jpg']; // Imagen por defecto
    }

    try {
      // Limpieza inicial del string
      String cleanedString = fotosString.trim();

      // Caso 1: Si es un JSON válido con escapes (menos común)
      if (cleanedString.startsWith(r'{\"') || cleanedString.startsWith('{"')) {
        cleanedString =
            cleanedString.replaceAll(r'\"', '"').replaceAll('\\"', '"');
      }

      // Caso 2: Si tiene comillas dobles externas (como en tu ejemplo)
      if (cleanedString.startsWith('{"') && cleanedString.endsWith('"}')) {
        cleanedString = cleanedString.substring(1, cleanedString.length - 1);
      }

      // Reemplazar comillas dobles restantes si las hay
      cleanedString = cleanedString.replaceAll('"', '');

      // Dividir por comas y limpiar cada URL
      List<String> urls = cleanedString
          .split(',')
          .map((url) => url.trim())
          .where((url) => url.startsWith('http'))
          .toList();

      return urls;
    } catch (e) {
      print('Error parsing images: $e');
      return [];
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
            _buildPostulacionesList(context),
            _buildMisTrabajosList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.orange,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text(_errorMessage)),
                    ),
                  ],
                )
              : _publicaciones.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(
                            child: Text('No hay publicaciones disponibles'),
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: _publicaciones.where((pub) {
                        // Verifica si hay alguna postulación para esta publicación
                        final yaPostulado = _postulaciones.any(
                          (post) => post['id_publicacion'] == pub['id'],
                        );
                        return !yaPostulado; // Mostrar solo si NO hay postulación
                      }).toList(),
                      nombresClientes: _nombresClientes,
                      onVerDetalles: (publicacion, nombreCliente) {
                        _mostrarDetalleTrabajo(
                            publicacion, nombreCliente, false);
                      },
                    ),
    );
  }

  Widget _buildPostulacionesList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadPostulaciones,
      color: Colors.orange,
      child: _isLoadingPostulaciones
          ? const Center(child: CircularProgressIndicator())
          : _errorMessagePostulaciones.isNotEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text(_errorMessagePostulaciones)),
                    ),
                  ],
                )
              : _postulaciones.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(
                            child: Text('No tienes postulaciones aún'),
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: _postulaciones
                          .where((postulacion) =>
                              postulacion['estado'] != 'aceptado')
                          .map((postulacion) {
                            final idPublicacion = postulacion['id_publicacion'];
                            final publicacion = _publicaciones.firstWhere(
                              (pub) => pub['id'] == idPublicacion,
                              orElse: () => null,
                            );
                            return publicacion;
                          })
                          .where((pub) => pub != null)
                          .toList(),
                      nombresClientes: _nombresClientes,
                      onVerDetalles: _mostrarDetalleDesdePostulacion,
                    ),
    );
  }

  Widget _buildMisTrabajosList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadPostulaciones,
      color: Colors.orange,
      child: _isLoadingPostulaciones
          ? const Center(child: CircularProgressIndicator())
          : _errorMessagePostulaciones.isNotEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(child: Text(_errorMessagePostulaciones)),
                    ),
                  ],
                )
              : _postulacionesAceptadas.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(
                            child: Text('Aún no tienes trabajos aceptados'),
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: _postulacionesAceptadas
                          .map((postulacion) {
                            final idPublicacion = postulacion['id_publicacion'];
                            final publicacion = _publicaciones.firstWhere(
                              (pub) => pub['id'] == idPublicacion,
                              orElse: () => null,
                            );
                            return publicacion;
                          })
                          .where((pub) => pub != null)
                          .toList(),
                      nombresClientes: _nombresClientes,
                      onVerDetalles: _mostrarDetalleDesdePostulacion,
                    ),
    );
  }
}
