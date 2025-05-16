import 'package:flutter/material.dart';
import 'package:nodo/app_colors.dart';
import 'package:nodo/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'providers/usuario_provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UsuarioProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            useMaterial3: true,
          ),
          home: LoginScreen(),
        );
      },
    );
    //return MaterialApp(
    //  debugShowCheckedModeBanner: false,
    //  title: 'Flutter Demo',
    //  theme: ThemeData(
    //    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //    useMaterial3: true,
    //  ),
    //  home: LoginScreen(),
    //);
  }
}
