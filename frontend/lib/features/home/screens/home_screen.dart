import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/shared/widgets/barra_navegacion_widget.dart';
import 'package:nodo/features/create_post/screens/create_post_screen.dart';
import 'package:nodo/features/notifications/screens/notifications_screen.dart';
import 'package:nodo/features/posts/screens/posts_screen.dart';
import 'package:nodo/features/trabajos/screens/trabajos2.dart';
import 'package:nodo/features/trabajos/screens/trabajos1.dart';
import 'package:nodo/shared/providers/user_provider.dart';
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
      const PostsScreen(),
      trabajosScreen,
      const CreatePostScreen(),
      const NotificationsScreen(),
      const ChatScreen(),
    ];
  }*/

  void _initializeScreens() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final Widget trabajosScreen = userProvider.isWorker
        ? const JobsScreen2()
        : const JobsScreen1();

    _screens = [
      const PostsScreen(),
      trabajosScreen,
      const CreatePostScreen(),
      const NotificationsScreen(),
      //const CreatePostScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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

                  //Avatar
                  children: [
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        final fotoPerfil = userProvider.user?.fotoPerfil;

                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.white,
                          backgroundImage:
                              (fotoPerfil != null && fotoPerfil.isNotEmpty)
                                  ? NetworkImage(fotoPerfil)
                                  : null,
                          child: (fotoPerfil == null || fotoPerfil.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 90,
                                  color: AppColors.white,
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(width: 15),

                    //Datos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row( 
                            children: [
                              Text("${user?.nombres.split(' ').first}",
                                  style: AppTypography.subtitle
                                      .copyWith(color: AppColors.white)),
                              
                              Text(
                                  ' ${user?.primerApellido}' ,
                                  style: AppTypography.subtitle
                                      .copyWith(color: AppColors.white)),
                            ],
                          ),
                          Text(user?.tipoUsuario ?? "Sin tipo",
                              style: AppTypography.label
                                  .copyWith(color: AppColors.white)),
                          const SizedBox(height: 4),
                          if (user?.tipoUsuario == 'trabajador')
                            Text(
                                "${user?.trabajosCompletados ?? 0} trabajos completados",
                                style: AppTypography.label
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

            if (user?.tipoUsuario != 'trabajador') 
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