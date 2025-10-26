import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/features/register/widgets/form_widget.dart';
import 'package:nodo/features/register/widgets/validation_widget.dart';
import 'package:nodo/features/register/widgets/profile_picture_widget.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 2;

  void nextStep() {
    setState(() {
      currentStep++;
    });

    // Si ya terminó, ir al login
    if (currentStep > 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Widget getStepWidget() {
    switch (currentStep) {
      case 0:
        return FormWidget(onContinue: nextStep);
      case 1:
        return ValidationWidget(onContinue: nextStep);
      case 2:
        return ProfilePictureWidget(onContinue: nextStep);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue, // Fondo azul detrás del contenido
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        toolbarHeight: 72.h,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/iconNodoWhite.png',
              width: 40.w,
              height: 40.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 12.w),
            Text(
              'Registro',
              style: AppTypography.h2.copyWith(
                color: AppColors.white,
                fontFamily: 'GothamBook',
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            // 🔹 Fondo con el logo
            Positioned.fill(
              child: Opacity(
                  opacity:
                      0.08, // 🔸 Ajusta la transparencia (0 = invisible, 1 = opaco)
                  child: Transform.scale(
                    scale: 2.sp,
                    child: Image.asset(
                      'assets/icons/iconNodoBlue.png', // cambia por la ruta de tu logo
                      fit: BoxFit.contain,
                      //alignment: Alignment.center,
                      height: 1800.h,
                      width: 1800.w,
                    ),
                  )),
            ),

            // 🔹 Contenido principal
            Column(
              children: [
                Expanded(
                  child: getStepWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
