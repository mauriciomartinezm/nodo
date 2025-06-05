import 'package:flutter/material.dart';

import 'package:nodo/features/trabajos/screens/trabajos3.dart';
import 'package:nodo/features/trabajos/screens/trabajos6.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService .dart'; // Asegúrate de importar aquí
import 'package:nodo/features/trabajos/widgets/joblist.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final publicaciones = await TrabajoService.fetchPublicaciones();
      final nombres = await TrabajoService.fetchNombresClientes(publicaciones);

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

  void _mostrarDetalleTrabajo(dynamic publicacion, String nombreCliente) {
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
            "title": publicacion['titulo'],
            "description": publicacion['descripcion_necesidad'],
            "price": "\$${publicacion['presupuesto']}",
            "location": "${publicacion['ubicacion']}",
            "user": "Nombre del cliente: $nombreCliente",
            "time":
                "${TrabajoService.formatTimeAgo(publicacion['fecha_publicacion'])} · ${publicacion['estado']}",
            "image": TrabajoService.getIconForCategory(publicacion['id_categoria']),
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

    return JobList(
      publicaciones: _publicaciones,
      nombresClientes: _nombresClientes,
      onVerDetalles: _mostrarDetalleTrabajo,
    );
  }

}