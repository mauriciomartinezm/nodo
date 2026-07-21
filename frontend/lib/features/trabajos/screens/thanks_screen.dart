import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class ThanksScreen extends StatelessWidget {
  const ThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Gracias por tu reporte',
                    style: AppTypography.title
                        .copyWith(color: const Color(0xFF003366)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.body.copyWith(color: Colors.black54),
                      children: [
                        const TextSpan(
                            text:
                                'Gracias por tomarte el tiempo de reportar esta publicación. El equipo de moderación revisará tu reporte en las próximas horas y tomará las '),
                        TextSpan(
                          text: 'medidas necesarias',
                          style: AppTypography.body.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                        const TextSpan(
                            text:
                                ' si la publicación no cumple con nuestras políticas de contenido.'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    int count = 0;
                    Navigator.popUntil(context, (_) => count++ >= 3);
                  },
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}