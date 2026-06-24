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
            ...team.map((member) => MemberCard(member)),
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


final List<TeamMember> team = [
  //TeamMember(
  //  name: 'Lusho Moreno',
  //  role: 'Creador de la idea, dirección general del proyecto',
  //  image: 'assets/icons/iconNodoBlue.png',
  //),
  TeamMember(
    name: 'Kehiber Leandro Morelo Ricardo',
    role: 'Estudiante de Ingeniería Informática',
    image: 'assets/icons/iconNodoBlue.png',
  ),
  TeamMember(
    name: 'Luis Felipe Salgado Manco',
    role: 'Estudiante de Ingeniería Informática',
    image: 'assets/icons/iconNodoBlue.png',
  ),
  TeamMember(
    name: 'Mauricio Martínez Martínez',
    role: 'Estudiante de Ingeniería Informática',
    image: 'assets/icons/iconNodoBlue.png',
  ),
  TeamMember(
    name: 'Tomás Muñoz Galvez',
    role: 'Estudiante de Ingeniería Informática',
    image: 'assets/icons/iconNodoBlue.png',
  ),
];


class TeamMember {
  final String name;
  final String role;
  final String image;

  TeamMember({
    required this.name,
    required this.role,
    required this.image,
  });
}

class MemberCard extends StatelessWidget {
  final TeamMember member;

  const MemberCard(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              member.image,
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
                  member.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  member.role,
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
