import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class JobsScreen1 extends StatelessWidget {
  const JobsScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Trabajos',
          style: AppTypography.subtitle.copyWith(
              color: const Color(0xFF003366),
            ),
        ),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Color(0xFF90A4AE), 
              ),
              const SizedBox(height: 24),
              Text(
                'Esta sección es exclusiva para trabajadores',
                textAlign: TextAlign.center,
                style: AppTypography.subtitle.copyWith(
                  color: const Color.fromARGB(255, 246, 107, 65),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Parece que aún no eres trabajador en la plataforma. Aquí podrás gestionar los trabajos en los que te hayas postulado y los que hayas completado. Conviértete en trabajador y accede a oportunidades laborales',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: const Color(0xFF90A4AE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}