import 'package:flutter/material.dart';
import 'package:nodo/shared/widgets/barra_navegacion_widget.dart';
import 'package:nodo/features/crear_publicacion/screens/crear_publicacion_screen.dart';
import 'package:nodo/features/notificaciones/screens/notificaciones_screen.dart';
import 'package:nodo/features/publicaciones/screens/publicaciones_screen.dart';
import 'package:nodo/features/trabajos/screens/trabajos2.dart';
import 'package:nodo/features/trabajos/screens/trabajos1.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  late List<Widget> _screens;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeScreens();
      _initialized = true;
    }
  }

  /*void _initializeScreens() {
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
      const TrabajosScreen2(), // Trabajos
      ChangeNotifierProvider(
        create: (context) => CrearPublicacionController(
          CrearPublicacionService(),
        ),
        child: const CrearPublicacionScreen(),
      ),
      const NotificacionesScreen(), // Notificaciones
      const CrearPublicacionScreen(), // Menú
    ];
  }*/

  void _initializeScreens() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final Widget trabajosScreen = userProvider.isWorker 
        ? const TrabajosScreen2()
        : const TrabajosScreen1();
        
    _screens = [
      const PublicacionesScreen(),
      trabajosScreen,
      const CrearPublicacionScreen(),
      const NotificacionesScreen(),
      const CrearPublicacionScreen(),
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
