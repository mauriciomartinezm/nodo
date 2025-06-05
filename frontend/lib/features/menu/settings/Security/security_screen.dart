import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class SecuritysScreen extends StatelessWidget {
  const SecuritysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seguridad',
          style: AppTypography.h1,
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Autenticación en dos pasos',
                  style: AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/editProfile');
              },
            ),

            ListTile(
              title: Text('Gesionar dispositivos conectados',
                  style: AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/editProfile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
