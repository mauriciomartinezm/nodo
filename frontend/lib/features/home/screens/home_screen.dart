import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }
/*
  void initState() {
    super.initState();
    _initializeScreens();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }
*/
  /*void _initializeScreens() {
    _screens = [
      const PublicacionesScreen(),
      trabajosScreen,
      const CrearPublicacionScreen(),
      const NotificacionesScreen(),
      const ChatScreen(),
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
      //const CrearPublicacionScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _screens,
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ProfileScreen');
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      // backgroundImage: AssetImage("assets/images/peter.jpg"),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Peter Parker",
                              style: AppTypography.h1.copyWith(
                                  color: AppColors
                                      .white)), // <-- puedes obtener el nombre del UserProvider aquí
                          Text("Fotógrafo",
                              style: AppTypography.body
                                  .copyWith(color: AppColors.white)),
                          const SizedBox(height: 4),
                          Text("3 Trabajos completados",
                              style: AppTypography.body
                                  .copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            drawerTile(Icons.settings, "Ajustes", '/SettingsScreen'),
            drawerTile(Icons.work_rounded, "Trabajar con NODO", '/workWNodo'),
            drawerTile(Icons.info_rounded, "Acerca de", '/About'),
            const Spacer(),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () async {
                  // 1. Cerrar el drawer primero
                  Navigator.of(context).pop();
                  //Navigator.pushNamed(context, '/logout');
                  // 2. Mostrar diálogo de confirmación
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content:
                          const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sí, cerrar sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                      // Muestra un indicador de carga
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => PopScope(
                          canPop: false,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );

                      // Ejecuta el logout (que ahora incluye toda la limpieza)
                      await Provider.of<UserProvider>(context, listen: false)
                          .logout();
                      print("Usuario desloggeado");
                      // Navega al login
                      // 5. Navegar al login - FORMA CORREGIDA
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                      );
                    }
                },
                child: Row(
                  children: const [
                    Icon(Icons.power_settings_new_rounded,
                        color: AppColors.blue),
                    SizedBox(width: 10),
                    Text("Cerrar sesión",
                        style: TextStyle(color: AppColors.blue)),
                    Spacer(),
                    Text("Versión 1.0",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            )
          ],
        ),
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

  Widget drawerTile(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: AppColors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}