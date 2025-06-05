import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes', style: AppTypography.h1, ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar ajustes',
                hintStyle: TextStyle(color: AppColors.orange),
                filled: true,
                fillColor: AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.orange),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de opciones
            _settingsOption(Icons.person_outline, 'Cuenta y Perfil', () {
              Navigator.pushNamed(context, '/AccountProfileScreen');
            }),
            _settingsOption(Icons.notifications_none, 'Notificaciones', () {
              Navigator.pushNamed(context, '/NotificationSettingsScreen');
            }),
            _settingsOption(Icons.tune, 'Preferencias', () {
              Navigator.pushNamed(context, '/PreferencesScreen');
            }),
            _settingsOption(Icons.credit_card, 'Pagos y facturación', () {
              Navigator.pushNamed(context, '/PaymentsBillings');
            }),

            _settingsOption(Icons.security, 'Seguridad', () {
              Navigator.pushNamed(context, '/SecuritysScreen');
            }),
          ],
        ),
      ),
    );
  }

  Widget _settingsOption(IconData icon, String title, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: AppColors.blue, size: 25),
      title: Text(
        title,
        style: AppTypography.h2.copyWith(color: AppColors.blue),
      ),
      onTap: onTap,
    );
  }
}
