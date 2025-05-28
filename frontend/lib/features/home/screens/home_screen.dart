import 'package:flutter/material.dart';
import 'package:nodo/shared/widgets/barra_navegacion_widget.dart';
import 'package:nodo/features/crear_publicacion/screens/crear_publicacion_screen.dart';
import 'package:nodo/features/notificaciones/screens/notificaciones_screen.dart';
import 'package:nodo/features/publicaciones/screens/publicaciones_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  // Lista de pantallas/páginas
  final List<Widget> _screens = [
    const PublicacionesScreen(), // Publicaciones
    const CrearPublicacionScreen(), // Trabajos
    const CrearPublicacionScreen(), // Publicar
    const NotificacionesScreen(), // Notificaciones
    const CrearPublicacionScreen(), // Menú
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _screens,
      ),
      bottomNavigationBar: 
      BarraNavegacionWidget(
        
          currentIndex: currentPageIndex,
          onIndexChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          }),
    );
  }
}
