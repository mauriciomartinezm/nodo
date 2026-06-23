import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class Credits extends StatelessWidget {
  const Credits({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        title: Text('Créditos / equipo de trabajo', style: AppTypography.title),
        // leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Conoce al equipo detrás de NODO',
              style: AppTypography.subtitle.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 8),
            Text(
              'Creamos esta plataforma con pasión, propósito y compromiso para ayudarte a conectar y crecer.',
              style: AppTypography.body.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 24),
            ...equipo.map((miembro) => TarjetaMiembro(miembro)),
            SizedBox(height: 80),

            Text(
              'Agradecimientos especiales a todas las personas que han probado, aportado ideas y creído en Nodo desde el inicio.',
              style: AppTypography.subtitle.copyWith(color: AppColors.blue),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            Text(
              'Hecho con 🧡 desde las bananeras de Urabá',
              style: AppTypography.label.copyWith(color: AppColors.blue),
            ),

            SizedBox(height: 80),

            Text(
              'Versión Nodo 2025',
              style: AppTypography.caption.copyWith(color: AppColors.blue),
            ),
            Text(
              'Todos los derechos reservados.',
              style: AppTypography.caption.copyWith(color: AppColors.blue),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
    );
  }
}

  
final List<MiembroEquipo> equipo = [
  //MiembroEquipo(
  //  nombre: 'Lusho Moreno',
  //  rol: 'Creador de la idea, dirección general del proyecto',
  //  imagen: 'assets/icons/iconNodoBlue.png',
  //),
  MiembroEquipo(
    nombre: 'Kehiber Leandro Morelo Ricardo',
    rol: 'Estudiante de Ingeniería Informática',
    imagen: 'assets/icons/iconNodoBlue.png',
  ),
  MiembroEquipo(
    nombre: 'Luis Felipe Salgado Manco',
    rol: 'Estudiante de Ingeniería Informática',
    imagen: 'assets/icons/iconNodoBlue.png',
  ),
  MiembroEquipo(
    nombre: 'Mauricio Martínez Martínez',
    rol: 'Estudiante de Ingeniería Informática',
    imagen: 'assets/icons/iconNodoBlue.png',
  ),
  MiembroEquipo(
    nombre: 'Tomás Muñoz Galvez',
    rol: 'Estudiante de Ingeniería Informática',
    imagen: 'assets/icons/iconNodoBlue.png',
  ),
];


class MiembroEquipo {
  final String nombre;
  final String rol;
  final String imagen;

  MiembroEquipo({
    required this.nombre,
    required this.rol,
    required this.imagen,
  });
}

class TarjetaMiembro extends StatelessWidget {
  final MiembroEquipo miembro;

  const TarjetaMiembro(this.miembro, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              miembro.imagen,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  miembro.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  miembro.rol,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text('"Inserte palabras emotivas"'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
