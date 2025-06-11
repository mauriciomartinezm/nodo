import 'package:flutter/material.dart';

import 'package:nodo/features/trabajos/screens/trabajos3.dart';
import 'package:nodo/features/trabajos/screens/trabajos6.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService.dart'; // Asegúrate de importar aquí
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
        ),
      ),
    );
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
            const Center(child: Text("Mis postulaciones")),
            const Center(child: Text("Mis trabajos")),
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
              ? Center(child: Text(_errorMessage))
              : _publicaciones.isEmpty
                  ? const Center(
                      child: Text('No hay publicaciones disponibles'))
                  : JobList(
                      publicaciones: _publicaciones,
                      nombresClientes: _nombresClientes,
                      onVerDetalles: _mostrarDetalleTrabajo,
                    ),
    );
  }
}
