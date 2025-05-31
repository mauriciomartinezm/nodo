import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nodo/core/theme/app_colors.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/features/welcome/widgets/welcome1.dart';
import 'providers/userprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final firstTime = await isFirstTime();
  bool firstTime = false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
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

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            useMaterial3: true,
          ),
          home: firstTime ? const Welcome1Screen() : const LoginScreen(),
        );
      },
    );
  }
}
