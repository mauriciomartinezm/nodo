import 'package:flutter/material.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_controller.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_service.dart';
import 'package:nodo/features/publicaciones/logic/publicaciones_controller.dart';
import 'package:nodo/features/publicaciones/logic/publicaciones_service.dart';
import 'package:nodo/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_colors.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/features/welcome/widgets/welcome1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/userprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Configura la clave global antes de inicializar NotificationService
  NotificationService.navigatorKey = GlobalKey<NavigatorState>();
  await NotificationService.requestPermissions();
  await NotificationService.initialize(); // Añade esta línea
  //await NotificacionService.instance.initialize();
  // Inicialización para Android y iOS
  final firstTime = await isFirstTime();
  //Firebase Cloud Messaging para las notificaciones push

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                CrearPublicacionController(CrearPublicacionService())),
        ChangeNotifierProvider(
          create: (context) => PublicacionesController(
            PublicacionesService(
              Provider.of<UserProvider>(context, listen: false),
            ),
          ),
        ),
      ],
      child: MyApp(firstTime: firstTime),
    ),
  );
}

Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('seen_welcome') ?? false;

  if (!seen) {
    await prefs.setBool('seen_welcome', true);
    return true;
  }

  return false;
}

class MyApp extends StatelessWidget {
  final bool firstTime;
  const MyApp({super.key, required this.firstTime});
  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: NotificationService.navigatorKey, // Usa la misma clave
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            useMaterial3: true,
          ),
          // home: const Welcome1Screen(),
          home: firstTime ? const Welcome1Screen() : const LoginScreen(),
        );
      },
    );
  }
}
