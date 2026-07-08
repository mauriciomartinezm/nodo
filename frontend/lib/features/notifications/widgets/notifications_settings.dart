// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool disableAll = false;
  bool disablePosts = false;
  bool realTimeNotifications = false;
  bool realTimeSummary = false;

  String? selectedFrequency;

  Widget _buildSectionTitle(String text) {
    return
    //Padding(
    //  padding: EdgeInsets.symmetric(vertical: 8.h),
    //  child:
      Text(
        text,
        style: AppTypography.label
            .copyWith(color: AppColors.blue),
      );
    //  ,
    //);
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7, // Ajuste para hacer el switch más pequeño
                      child: Switch(
                        value: value,
                        onChanged: onChanged,
                        activeThumbColor: Colors
                            .white, // Color del círculo cuando está activo
                        activeTrackColor: AppColors
                            .blue, // Color del fondo cuando está activo
                        inactiveThumbColor: AppColors
                            .blue, // Color del círculo cuando está inactivo
                        inactiveTrackColor: Colors
                            .transparent, // Fondo transparente cuando está inactivo
                      ),
                    ),
                    Text(
                      title,
                      style: AppTypography.label.copyWith(color: AppColors.blue),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(color: AppColors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption(String text, String value) {
    return CheckboxListTile(
      activeColor: AppColors.blue,
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
      title: Text(
        text,
        style: AppTypography.caption.copyWith(color: AppColors.blue),
      ),
      value: selectedFrequency == value,
      onChanged: (bool? selected) {
        setState(() {
          selectedFrequency = selected! ? value : null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configura tus notificaciones',
          style: AppTypography.body.copyWith(color: AppColors.blue),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            Text(
              'Elige cómo quieres recibir notificaciones sobre nuevas publicaciones y actualizaciones de tu cuenta.',
              style: AppTypography.label.copyWith(color: AppColors.blue),
            ),
            Divider(height: 12.h, thickness: 1, color: AppColors.orange),
            _buildSwitchTile(
              'Desactivar todas las publicaciones',
              'Ten en cuenta que no recibirás notificaciones, excepto aquellas importantes sobre tu cuenta.',
              disableAll,
              (value) => setState(() => disableAll = value),
            ),
            Divider(height: 12.h, thickness: 1, color: AppColors.orange),
            _buildSectionTitle('Publicaciones de clientes'),
            _buildSwitchTile(
              'Desactivar notificaciones de publicaciones',
              'No recibirás notificaciones acerca de las publicaciones pero podrás checar las publicaciones en el apartado de publicaciones.',
              disablePosts,
              (value) => setState(() => disablePosts = value),
            ),
            _buildSwitchTile(
              'Notificaciones en tiempo real',
              'Recibe una notificación cada vez que un cliente publique un servicio de tu rubro.',
              realTimeNotifications,
              (value) => setState(() => realTimeNotifications = value),
            ),
            _buildSwitchTile(
              'Resumen en tiempo real',
              'Recibe un resumen de las nuevas publicaciones en tu rubro cada cierto tiempo.',
              realTimeSummary,
              (value) => setState(() => realTimeSummary = value),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                'Frecuencia:',
                style: AppTypography.caption.copyWith(color: AppColors.blue),
              ),
            ),
            _buildFrequencyOption('Cada 2 horas', '2h'),
            _buildFrequencyOption('Cada 6 horas', '6h'),
            _buildFrequencyOption('Diario', '1d'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Preferencias guardadas')),
            );
          },
          child: Text(
            'Guardar preferencias',
            style: AppTypography.label.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
