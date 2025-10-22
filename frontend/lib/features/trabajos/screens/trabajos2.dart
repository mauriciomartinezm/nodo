import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

import 'package:nodo/features/trabajos/screens/trabajos3.dart';
import 'package:nodo/features/trabajos/screens/trabajos6.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService.dart'; // Asegúrate de importar aquí
import 'package:nodo/features/trabajos/widgets/joblist.dart';
import 'package:nodo/providers/user_provider.dart';
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
  List<dynamic> _postulacionesConsideradas = [];

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
    final currentId = userProvider.user?.id; // o userProvider.cedula
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
    final currentId = userProvider.user?.id;
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
      final consideradas =
          postulaciones.where((p) => p['estado'] == 'considerado').toList();

      setState(() {
        _postulaciones = postulaciones;
        _postulacionesPendientes = pendientes;
        _postulacionesAceptadas = aceptadas;
        _postulacionesRechazadas = rechazadas;
        _postulacionesConsideradas = consideradas;
        _isLoadingPostulaciones = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPostulaciones = false;
        _errorMessagePostulaciones = 'Error: $e';
      });
    }
  }

  void _mostrarDetalleTrabajo(dynamic publicacion, String nombreCliente,
      Map<String, dynamic>? postulacion, bool desdePostulaciones) {
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
          postulacion: postulacion,
          scrollController: scrollController,
          desdePostulaciones: desdePostulaciones,
          onPostulacionCambiada: _loadAllData, // <--- LLAMADO AL REFRESCO
        ),
      ),
    );
  }

  void _mostrarDetalleDesdePostulacion(dynamic publicacion, String _) {
    final idCliente = publicacion['id_cliente'];
    print("nombres de clientes");
    print(_nombresClientes);
    print(idCliente);
    final postulacion = _postulaciones.firstWhere(
      (p) => p['id_publicacion'] == publicacion['id'],
      orElse: () => null,
    );

    final nombreCliente = _nombresClientes[idCliente.toString()] ?? 'Cliente';
    print("Nombre del cliente: ");
    print(nombreCliente);
    print("Informacion de la postulacion: ");
    print(postulacion);
    _mostrarDetalleTrabajo(publicacion, nombreCliente, postulacion, true);
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
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
              icon: const Icon(Icons.filter_alt_outlined, color: AppColors.orange),
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
      onRefresh: _loadAllData,
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
                            publicacion, nombreCliente, null, false);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 40.0),
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.work_outline,
                                  size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Aún no te has postulado a ningún trabajo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Explora las oportunidades disponibles y postúlate para comenzar a trabajar. Postúlate a los trabajos que mejor se adapten a tus habilidades y experiencia.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: _postulaciones
                          .where((postulacion) =>
                              postulacion['estado'] != 'aceptado' && postulacion['estado'] != 'finalizada')
                          .map((postulacion) {
                            final idPublicacion = postulacion['id_publicacion'];
                            final publicacion = _publicaciones.firstWhere(
                              (pub) => pub['id'] == idPublicacion,
                              orElse: () => null,
                            );
                            if (publicacion != null) {
                              publicacion['estado_postulacion'] =
                                  postulacion['estado']; // 👈 AÑADIDO
                            }
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
    final trabajos = _postulaciones.where((post) =>
    post['estado'] == 'aceptado' || post['estado'] == 'finalizada'
  ).toList();
    return RefreshIndicator(
      onRefresh: _loadAllData,
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
              : trabajos.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(
                            child: Text('Aún no tienes trabajos aceptados ni finalizados'),
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: trabajos
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
