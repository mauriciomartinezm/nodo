import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class SecuritysScreen extends StatelessWidget {
  const SecuritysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seguridad',
          style: AppTypography.title,
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
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/editProfile');
              },
            ),

            ListTile(
              title: Text('Gesionar dispositivos conectados',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
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
