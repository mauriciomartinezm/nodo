import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.usuario;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.blue),
            onPressed: () {
              Navigator.pushNamed(context, '/SettingsScreen');
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                //Portada y Avatar
                Stack(
                  clipBehavior: Clip.none, //Permite que el puto avatar se sobreponga en la portada
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
                        padding: const EdgeInsets.all(4), //Grosor del contorno
                        decoration: BoxDecoration(
                          color: AppColors.white, //Color del contorno
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.orange,
                          child: Icon(
                            Icons.person,
                            size: 90,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    //Boton editar
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 155, right: 0),
                        child: TextButton.icon(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.blue),
                          label: Text('Editar',
                              style: AppTypography.h3
                                  .copyWith(color: AppColors.blue)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Contenido
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Nombre y tipo
                      Text(user.nombres,
                          style:AppTypography.h2
                              .copyWith(color: AppColors.blue)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(user.tipoUsuario,
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
                            const SizedBox(width: 4),
                            Text('${user.calificacionPromedio}',
                                style: AppTypography.h3
                                    .copyWith(color: AppColors.blue)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            Text('Trabajos completados ',
                                style: AppTypography.body
                                    .copyWith(color: AppColors.blue)),
                            const SizedBox(width: 4),
                            Text(
                                '${user.trabajosCompletados}',
                                style: AppTypography.h3
                                    .copyWith(color: AppColors.blue)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      //Información de contacto
                      _buildInfoSection(
                        title: "Correo",
                        content: user.email,
                      ),
                      _buildInfoSection(
                        title: "Número de contacto",
                        content: user.telefono,
                      ),
                      _buildInfoSection(
                        title: "Ubicación o ciudad",
                        content: user.ubicacion ?? 'No especificada',
                      ),
                      const SizedBox(height: 30),

                      //Descripción
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Descripción",
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              user.descripcion?.isNotEmpty == true
                                  ? user.descripcion!
                                  : "No hay descripción disponible",
                              style: AppTypography.h3
                                  .copyWith(color: AppColors.blue),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),

                      // Categorías
                      if (user.categoria != null && user.categoria!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Categorías",
                                style: AppTypography.body
                                    .copyWith(color: AppColors.blue)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: -4,
                                children: user.categoria!
                                    .map((tag) => Chip(
                                          label: Text(
                                            tag,
                                            style: AppTypography.body
                                                .copyWith(
                                                    color: AppColors.blue),
                                          ),
                                          backgroundColor: AppColors.white,
                                          side: BorderSide(
                                              color: AppColors.blue,
                                              width: 1.2),
                                        ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),

                      // Estadísticas
                      Text("Estadísticas",
                          style: AppTypography.h2
                              .copyWith(color: AppColors.blue)),
                      ListTile(
                        title: Text(
                          "Publicaciones en las que te has postulado",
                          style: AppTypography.h3
                              .copyWith(color: AppColors.blue),
                        ),
                        onTap: () => goToMisPostulaciones(context),
                      ),
                      ListTile(
                        title: Text("Trabajos completados",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(user.trabajosCompletados.toString(),
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                        ),
                        onTap: () => goToMisTrabajos(context),
                      ),
                      ListTile(
                        title: Text("Total ganado",
                            style: AppTypography.h3
                                .copyWith(color: AppColors.blue)),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text("\$${user.tipoUsuario}",
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
                          child: Text(_formatDate(user.fechaRegistro),
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Insignias
                      Text("Insignias",
                          style: AppTypography.h2
                              .copyWith(color: AppColors.blue)),
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

  Widget _buildInfoSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.body.copyWith(color: AppColors.blue)),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(content,
              style: AppTypography.h3.copyWith(color: AppColors.blue)),
        ),
        const SizedBox(height: 12),
      ],
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

  //Formato de fecha
  String _formatDate(String dateString) {
    try {
      //Parseo de la fecha
      final date = DateTime.parse(dateString);
      //Formateo fecha español (día mes año)
      return DateFormat('d MMMM y', 'es').format(date);
    } catch (e) {
      //Si hay error al parsear, devuelve la fecha original
      return dateString;
    }
  }
}
