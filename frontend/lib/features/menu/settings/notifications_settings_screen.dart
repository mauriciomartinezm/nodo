import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool disableAll = false;
  String? activeNotification; //publicaciones, tiempoReal, resumen
  String? selectedFrequency; //2h, 6h, diario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configura tus notificaciones',
          style: AppTypography.title.copyWith(color: AppColors.blue),
        ),
        leading: const BackButton(color: AppColors.blue),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            Text(
              'Elige cómo quieres recibir notificaciones sobre nuevas publicaciones y actualizaciones de tu cuenta, recuerda que si las desacativas, aún podrás checarlas en el apartado de notificaciones de la barra de navegación.',
              style: AppTypography.body.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Divider(color: AppColors.orange),

            //Desactivar todas
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text('Desactivar todas las notificaciones',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              subtitle: Text(
                'No se recibirás notificaciones, excepto por notificaciones importantes sobre tu cuenta que recibirás por el medio que hayas elegido.',
                style: AppTypography.body.copyWith(color: AppColors.blue),
                textAlign: TextAlign.justify,
              ),
              value: disableAll,
              onChanged: (val) {
                setState(() {
                  disableAll = val;
                  if (val) {
                    activeNotification = null;
                    selectedFrequency = null;
                  }
                });
              },
              activeThumbColor: AppColors.white, //Activo: Color de bola
              activeTrackColor: AppColors.blue, //Activo: Color de fondo

              inactiveThumbColor: AppColors.blue, //Inactivo: Color de bola
              inactiveTrackColor: AppColors.white, //Inactivo: Color de fondo
            ),

            // const SizedBox(height: 0),
            const Divider(color: AppColors.orange),
            const SizedBox(height: 8),

            Text('Mis publicaciones',
                style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
            const SizedBox(height: 8),

            _buildSwitchTile(
              title: 'Notificaciones de publicaciones',
              subtitle:
                  'Recibirás notificaciones sobre tus publicaciones',
              value: activeNotification == 'publicaciones',
              onChanged: (val) {
                if (!disableAll) {
                  setState(() {
                    activeNotification = 'publicaciones';
                    selectedFrequency = null;
                  });
                }
              },
              enabled: !disableAll,
            ),

            //Opción: Notificaciones en tiempo real
            _buildSwitchTile(
              title: 'Notificaciones en tiempo real',
              subtitle:
                  'Recibe una notificación cada vez que un cliente publique un servicio de tu rubro.',
              value: activeNotification == 'tiempoReal',
              onChanged: (val) {
                if (!disableAll) {
                  setState(() {
                    activeNotification = 'tiempoReal';
                    selectedFrequency = null;
                  });
                }
              },
              enabled: !disableAll,
            ),

            //Opción: Resumen en tiempo real
            _buildSwitchTile(
              title: 'Resumen en tiempo real',
              subtitle:
                  'Recibe un resumen de las nuevas publicaciones en tu rubro cada cierto tiempo.',
              value: activeNotification == 'resumen',
              onChanged: (val) {
                if (!disableAll) {
                  setState(() {
                    activeNotification = 'resumen';
                  });
                }
              },
              enabled: !disableAll,
            ),

            if (activeNotification == 'resumen') ...[
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: Text('Frecuencia:',
                    style: AppTypography.label.copyWith(color: AppColors.blue)),
              ),
              _CheckOption(
                title: 'Cada 2 horas',
                value: selectedFrequency == '2h',
                enabled: true,
                onChanged: (_) => setState(() => selectedFrequency = '2h'),
              ),
              _CheckOption(
                title: 'Cada 6 horas',
                value: selectedFrequency == '6h',
                enabled: true,
                onChanged: (_) => setState(() => selectedFrequency = '6h'),
              ),
              _CheckOption(
                title: 'Diario',
                value: selectedFrequency == 'daily',
                enabled: true,
                onChanged: (_) => setState(() => selectedFrequency = 'daily'),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            onPressed: () {
            },
            child: const Text('Guardar preferencias',
                style: TextStyle(color: AppColors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool enabled,
  }) {
    return SwitchListTile(
      title:
          Text(title, style: AppTypography.label.copyWith(color: AppColors.blue)),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Text(subtitle,
            style: AppTypography.body.copyWith(color: AppColors.blue),
            textAlign: TextAlign.justify),
      ),
      value: value,
      onChanged: enabled ? (val) => onChanged(val) : null,
      activeThumbColor: AppColors.white, //Activo: Color de bola
      activeTrackColor: AppColors.blue, //Activo: Color de fondo

      inactiveThumbColor: AppColors.blue, //Inactivo: Color de bola
      inactiveTrackColor: AppColors.white, //Inactivo: Color de fondo
    );
  }
}

class _CheckOption extends StatelessWidget {
  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool?> onChanged;

  const _CheckOption({
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: Text(title,
          style: AppTypography.body.copyWith(color: AppColors.blue)),
      activeColor: AppColors.blue,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}