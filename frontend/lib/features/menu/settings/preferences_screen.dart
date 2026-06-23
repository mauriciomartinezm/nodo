import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String idioma = 'Español';
  String ubicacion = 'Selecciona el municipio de tu preferencia';

  final List<String> municipiosUraba = [
    'Apartadó',
    'Turbo',
    'Carepa',
    'Chigorodó',
    'Mutatá',
    'San Pedro de Urabá',
    'Necoclí',
    'Arboletes',
    'Murindó',
    'Vigía del Fuerte',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias',
            style: AppTypography.title.copyWith(color: AppColors.blue)),
        leading: const BackButton(color: AppColors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text('Idioma',
                  style:
                      AppTypography.subtitle.copyWith(color: AppColors.blue)),
              subtitle: Text(idioma,
                  style: AppTypography.body.copyWith(color: AppColors.blue)),
              onTap: _editLanguaje,
            ),
            ListTile(
              title: Text('Ubicación Preferida',
                  style:
                      AppTypography.subtitle.copyWith(color: AppColors.blue)),
              subtitle: Text(ubicacion,
                  style: AppTypography.body.copyWith(color: AppColors.blue)),
              onTap: _editUbicacion,
            ),
          ],
        ),
      ),
    );
  }

  void _editLanguaje() {
    showDialog(
      context: context,
      barrierColor: AppColors.blue,
      builder: (_) => AlertDialog(
        title: Text('Idioma',
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: AppColors.blue)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NODO solo está disponible en español, pero sólo por ahora ;)',
              textAlign: TextAlign.justify,
              style: AppTypography.body.copyWith(color: AppColors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              
              onPressed: () => Navigator.pop(context),
              child: Text('Ok, bro',
                  style:
                      AppTypography.subtitle.copyWith(color: AppColors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  void _editUbicacion() {
    String seleccionTemporal = ubicacion;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Selecciona tu ubicación',
            style: AppTypography.title.copyWith(color: AppColors.blue)),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => DropdownButton<String>(
            value: municipiosUraba.contains(seleccionTemporal)
                ? seleccionTemporal
                : null,
            hint: Text('Selecciona un municipio',
                style: AppTypography.body.copyWith(color: AppColors.blue)),
            isExpanded: true,
            items: municipiosUraba.map((municipio) {
              return DropdownMenuItem<String>(
                value: municipio,
                child: Text(municipio,
                    style: AppTypography.body.copyWith(color: AppColors.blue)),
              );
            }).toList(),
            onChanged: (value) {
              setStateDialog(() => seleccionTemporal = value!);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTypography.body.copyWith(color: AppColors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ubicacion = seleccionTemporal;
              });
              Navigator.pop(context);
            },
            child: Text('Guardar',
                style: AppTypography.subtitle.copyWith(color: AppColors.orange)),
          ),
        ],
      ),
    );
  }
}