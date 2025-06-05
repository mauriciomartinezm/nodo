import 'package:flutter/material.dart';

class TrabajosScreen1 extends StatelessWidget {
  const TrabajosScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Trabajos',
          style: TextStyle(
            color: Color(0xFF003366), // Azul oscuro
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
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
              const Text(
                'Esta sección es exclusiva para trabajadores',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 246, 107, 65), 
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Parece que aún no eres trabajador en la plataforma. Aquí podrás gestionar los trabajos en los que te hayas postulado y los que hayas completado. Conviértete en trabajador y accede a oportunidades laborales',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF90A4AE), // Gris azulado
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}