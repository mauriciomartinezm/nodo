import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/shared/widgets/barra_navegacion_widget.dart';
import 'package:nodo/features/crear_publicacion/screens/crear_publicacion_screen.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_controller.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_service.dart';
import 'package:nodo/features/notificaciones/screens/notificaciones_screen.dart';
import 'package:nodo/features/publicaciones/screens/publicaciones_screen.dart';
import 'package:nodo/features/publicaciones/logic/publicaciones_controller.dart';
import 'package:nodo/features/publicaciones/logic/publicaciones_service.dart';
import 'package:nodo/providers/userprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      // Publicaciones Screen con su provider
      ChangeNotifierProvider(
        create: (context) => PublicacionesController(
          PublicacionesService(
            Provider.of<UserProvider>(context, listen: false),
          ),
        ),
        child: const PublicacionesScreen(),
      ),
      const CrearPublicacionScreen(), // Trabajos
      ChangeNotifierProvider(
        create: (context) => CrearPublicacionController(
          CrearPublicacionService(),
        ),
        child: const CrearPublicacionScreen(),
      ),
      const NotificacionesScreen(), // Notificaciones
      const CrearPublicacionScreen(), // Menú
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _screens,
      ),
      bottomNavigationBar: BarraNavegacionWidget(
        currentIndex: currentPageIndex,
        onIndexChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}