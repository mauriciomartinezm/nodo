// settings_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificacionesSettings extends StatefulWidget {
  const NotificacionesSettings({super.key});

  @override
  State<NotificacionesSettings> createState() => _NotificacionesSettingsState();
}

class _NotificacionesSettingsState extends State<NotificacionesSettings> {
  bool desactivarTodas = false;
  bool desactivarPublicaciones = false;
  bool notificacionesTiempoReal = false;
  bool resumenTiempoReal = false;

  String? frecuenciaSeleccionada;

  Widget _buildTituloSeccion(String texto) {
    return 
    //Padding(
    //  padding: EdgeInsets.symmetric(vertical: 8.h),
    //  child: 
      Text(
        texto,
        style: TextStyle(
            fontFamily: 'GothamMedium',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor),
      );
    //  ,
    //);
  }

  Widget _buildSwitchTile(
      String titulo, String subtitulo, bool valor, Function(bool) onChanged) {
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
                        value: valor,
                        onChanged: onChanged,
                        activeColor: Colors
                            .white, // Color del círculo cuando está activo
                        activeTrackColor: AppColors
                            .primaryColor, // Color del fondo cuando está activo
                        inactiveThumbColor: AppColors
                            .primaryColor, // Color del círculo cuando está inactivo
                        inactiveTrackColor: Colors
                            .transparent, // Fondo transparente cuando está inactivo
                      ),
                    ),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontFamily: 'GothamMedium',
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitulo,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'GothamBook',
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrecuenciaOption(String texto, String valor) {
    return CheckboxListTile(
      activeColor: AppColors.primaryColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
      title: Text(
        texto,
        style: TextStyle(
          fontSize: 10.sp,
          color: AppColors.primaryColor,
          fontFamily: 'GothamBook',
        ),
      ),
      value: frecuenciaSeleccionada == valor,
      onChanged: (bool? selected) {
        setState(() {
          frecuenciaSeleccionada = selected! ? valor : null;
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
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: 'GothamMedium',
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
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
              style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'GothamBook',
                  color: AppColors.primaryColor),
            ),
            Divider(height: 12.h, thickness: 1, color: AppColors.accentColor),
            _buildSwitchTile(
              'Desactivar todas las publicaciones',
              'Ten en cuenta que no recibirás notificaciones, excepto aquellas importantes sobre tu cuenta.',
              desactivarTodas,
              (valor) => setState(() => desactivarTodas = valor),
            ),
            Divider(height: 12.h, thickness: 1, color: AppColors.accentColor),
            _buildTituloSeccion('Publicaciones de clientes'),
            _buildSwitchTile(
              'Desactivar notificaciones de publicaciones',
              'No recibirás notificaciones acerca de las publicaciones pero podrás checar las publicaciones en el apartado de publicaciones.',
              desactivarPublicaciones,
              (valor) => setState(() => desactivarPublicaciones = valor),
            ),
            _buildSwitchTile(
              'Notificaciones en tiempo real',
              'Recibe una notificación cada vez que un cliente publique un servicio de tu categoría.',
              notificacionesTiempoReal,
              (valor) => setState(() => notificacionesTiempoReal = valor),
            ),
            _buildSwitchTile(
              'Resumen en tiempo real',
              'Recibe un resumen de las nuevas publicaciones en tu categoría cada cierto tiempo.',
              resumenTiempoReal,
              (valor) => setState(() => resumenTiempoReal = valor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                'Frecuencia:',
                style: TextStyle(
                    fontFamily: 'GothamMedium',
                    fontSize: 10.sp,
                    color: AppColors.primaryColor),
              ),
            ),
            _buildFrecuenciaOption('Cada 2 horas', '2h'),
            _buildFrecuenciaOption('Cada 6 horas', '6h'),
            _buildFrecuenciaOption('Diario', '1d'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            backgroundColor: AppColors.primaryColor,
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
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondaryColor,
              fontFamily: 'GothamMedium',
            ),
          ),
        ),
      ),
    );
  }
}
