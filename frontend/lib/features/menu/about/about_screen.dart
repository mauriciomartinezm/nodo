import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
        title: const Text(
          'Acerca de',
          style: AppTypography.h1,
        ),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Politica de tratamiento de datos',
                  style: AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/PaymentsMethods');
              },
            ),
            ListTile(
              title: Text('Politica de privacidad',
                  style: AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/editProfile');
              },
            ),
            ListTile(
              title: Text('Créditos / Equipo de desarrollo',
                  style: AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/Credits');
              },
            ),
            ListTile(
              title: Text('No pierdas el hilo, sigue el NODO',
                  style: AppTypography.h2.copyWith(color: AppColors.orange)),
              onTap: () {
                Navigator.pushNamed(context, '/YourIncome');
              },
            ),
          ],
        ),
      ),
    );
  }
}
