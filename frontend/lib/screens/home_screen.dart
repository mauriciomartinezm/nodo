import 'package:flutter/material.dart';
import 'package:nodo/widgets/barra_navegacion_widget.dart';
import 'package:nodo/screens/crear_publicacion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  // Lista de pantallas/páginas
  final List<Widget> _screens = [
    const CrearPublicacion(), // Publicar
    const CrearPublicacion(), // Trabajos
    const CrearPublicacion(), // Agregar algo
    const CrearPublicacion(), // Notificaciones
    const CrearPublicacion(), // Menú
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
