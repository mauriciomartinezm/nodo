import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.blue),
            onPressed: () {
              Navigator.pushNamed(context, '/SettingsScreen');
            },
          )
        ],
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Portada y Avatar
                Stack(
                  clipBehavior: Clip
                      .none, //Permite que el puto avatar se sobreponga en la portada
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          color: AppColors.blue,
                        ),
                        //linea inferior del borde
                        Container(
                          height: 15,
                          width: double.infinity,
                          color: AppColors.orange,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 80,
                      left: 16,
                      child: Container(
                        padding: EdgeInsets.all(4), //Grosor del borde
                        decoration: BoxDecoration(
                          color: AppColors.white, //Color del borde
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.orange,
                          child: Icon(
                            Icons.personal_injury_rounded,
                            size: 90,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 155, right: 0),
                        child: TextButton.icon(
                          icon:
                              Icon(Icons.edit_outlined, color: AppColors.blue),
                          label: Text('Editar',
                              style: AppTypography.h3
                                  .copyWith(color: AppColors.blue)),
                          onPressed: () {
                            debugPrint("Dddd");
                            Navigator.pushNamed(context, '/editProfile');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //Contenido
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 20, 16, 16), //iz arr derecha abj
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kehiber Leandro Morelo Ricardo',
                          style:
                              AppTypography.h2.copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('Trabajador',
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            Text('Calificación promedio: ',
                                style: AppTypography.body
                                    .copyWith(color: AppColors.blue)),
                            Text('4.5',
                                style: AppTypography.h3
                                    .copyWith(color: AppColors.blue)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            Text('Trabajos completados: ',
                                style: AppTypography.body
                                    .copyWith(color: AppColors.blue)),
                            Text('3',
                                style: AppTypography.h3
                                    .copyWith(color: AppColors.blue)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      //Datos personales
                      Text("Correo",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text("User@mail.com",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                      ),
                      const SizedBox(height: 12),
                      Text("Número de contacto",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text("0000000000",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                      ),
                      const SizedBox(height: 12),
                      Text("Ubicación o ciudad",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text("Apartadó - Antioquia",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                      ),

                      const SizedBox(height: 30),

                      // Descripción
                      Text("Descripción",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...",
                          style:
                              AppTypography.h3.copyWith(color: AppColors.blue),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Categorías
                      Text("Categorías",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: -4,
                          children: [
                            "Creativo",
                            "Carismático",
                            "Sociable",
                            "Responsable",
                            "Honesto",
                            "Aventurero",
                            "Optimista",
                            "Amable",
                            "Inteligente",
                            "Divertido",
                            "Curioso",
                            "Paciente",
                            "Apasionado",
                            "Guapo",
                            "Poderoso",
                            "Asombroso",
                            "Muy hermoso",
                            "Armonioso",
                          ]
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: AppTypography.body
                                          .copyWith(color: AppColors.blue),
                                    ),
                                    backgroundColor: AppColors.white,
                                    side: BorderSide(
                                        color: AppColors.blue, width: 1.2),
                                  ))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Estadísticas
                      Text("Estadísticas",
                          style:
                              AppTypography.h2.copyWith(color: AppColors.blue)),
                      ListTile(
                        title: Text(
                          "Publicaciones en las que te has postulado",
                          style:
                              AppTypography.h3.copyWith(color: AppColors.blue),
                        ),
                        onTap: () => goToMisPostulaciones(context),
                      ),
                      ListTile(
                        title: Text("Trabajos completados",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                        onTap: () => goToMisTrabajos(context),
                      ),
                      ListTile(
                        title: Text("Total ganado",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text("\$9999",
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                        ),
                      ),
                      ListTile(
                        title: Text("Miembro desde",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text("enero 2025",
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Insignias
                      Text("Insignias",
                          style:
                              AppTypography.h2.copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "Las insignias son un modo de reconocer los logros de los usuarios. Otros usuarios podrán verlas. Será una función que agregaremos próximamente ;)",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void goToMisPostulaciones(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ir a "Trabajos > Mis postulaciones"',
            style: AppTypography.h3.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.orange,
      ),
    );
  }

  void goToMisTrabajos(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ir a "Trabajos > Mis trabajos"',
            style: AppTypography.h3.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.orange,
      ),
    );
  }
}
