import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

import 'package:nodo/features/trabajos/screens/job_detail_screen.dart';
import 'package:nodo/features/trabajos/screens/category_filter_screen.dart';
import 'package:nodo/features/trabajos/logic/job_service.dart'; // Asegúrate de importar aquí
import 'package:nodo/features/trabajos/widgets/joblist.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:provider/provider.dart';

class JobsScreen2 extends StatefulWidget {
  const JobsScreen2({super.key});

  @override
  _JobsScreen2State createState() => _JobsScreen2State();
}

class _JobsScreen2State extends State<JobsScreen2> {
  List<dynamic> _publicaciones = [];
  Map<String, String> _nombresClientes = {};
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _postulaciones = [];

  bool _isLoadingPostulaciones = true;
  String _errorMessagePostulaciones = '';

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
    try {
      final publicaciones = await JobService.fetchPosts();
      final nombres = await JobService.fetchClientNames(publicaciones);

      setState(() {
        _publicaciones = publicaciones;
        _nombresClientes = nombres;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _loadPostulaciones() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentId = userProvider.user?.id;
    if (currentId == null) return;

    try {
      final postulaciones = await JobService.fetchApplicationsByUser(currentId);

      setState(() {
        _postulaciones = postulaciones;
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
    final categories = (publicacion['categories'] as List?) ?? [];
    final firstCategoryId =
        categories.isNotEmpty ? categories[0]['specificCategoryId'] : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => JobDetailScreen(
          job: {
            "id": publicacion['id'],
            "title": publicacion['title'],
            "description": publicacion['description'],
            "price": "\$${publicacion['budget']}",
            "location": "${publicacion['location']}",
            "user": "Nombre del cliente: $nombreCliente",
            "time":
                "${JobService.formatTimeAgo(publicacion['postDate'])} · ${publicacion['status']}",
            "image": JobService.getIconForCategory(firstCategoryId),
            "images": _parseImages(publicacion['photos']),
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
    final idCliente = publicacion['clientId'];
    final postulacion = _postulaciones.firstWhere(
      (p) => p['postId'] == publicacion['id'],
      orElse: () => null,
    );

    final nombreCliente = _nombresClientes[idCliente.toString()] ?? 'Cliente';
    _mostrarDetalleTrabajo(publicacion, nombreCliente, postulacion, true);
  }

  List<String> _parseImages(dynamic photos) {
    if (photos is List && photos.isNotEmpty) {
      return photos.map((url) => url.toString()).toList();
    }
    return ['assets/images/diomedes_joven.jpg']; // Imagen por defecto
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            'Trabajos',
            style: AppTypography.subtitle.copyWith(
              color: const Color(0xFF003366),
            ),
          ),
          bottom: TabBar(
            labelColor: const Color(0xFF003366),
            unselectedLabelColor: Colors.grey,
            labelStyle: AppTypography.body,
            indicatorColor: const Color(0xFF003366),
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
              icon: const Icon(Icons.filter_alt_outlined,
                  color: AppColors.orange),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CategoryFilterScreen(),
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
                          (post) => post['postId'] == pub['id'],
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
                            children: [
                              const Icon(Icons.work_outline,
                                  size: 80, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                'Aún no te has postulado a ningún trabajo',
                                textAlign: TextAlign.center,
                                style: AppTypography.title.copyWith(
                                  color: const Color(0xFF003366),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Explora las oportunidades disponibles y postúlate para comenzar a trabajar. Postúlate a los trabajos que mejor se adapten a tus habilidades y experiencia.',
                                textAlign: TextAlign.center,
                                style: AppTypography.subtitle
                                    .copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: _postulaciones
                          .where((postulacion) =>
                              postulacion['status'] != 'accepted')
                          .map((postulacion) {
                            final idPublicacion = postulacion['postId'];
                            final publicacion = _publicaciones.firstWhere(
                              (pub) => pub['id'] == idPublicacion,
                              orElse: () => null,
                            );
                            if (publicacion != null) {
                              publicacion['estado_postulacion'] =
                                  postulacion['status']; // 👈 AÑADIDO
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
    final trabajos =
        _postulaciones.where((post) => post['status'] == 'accepted').toList();
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
                            child: Text(
                                'Aún no tienes trabajos aceptados ni finalizados'),
                          ),
                        ),
                      ],
                    )
                  : JobList(
                      publicaciones: trabajos
                          .map((postulacion) {
                            final idPublicacion = postulacion['postId'];
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
