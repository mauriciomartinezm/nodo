import 'package:flutter/material.dart';
import 'package:nodo/features/publicaciones/screens/publicaciones_screen.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //Portada
                    Column(
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          color: AppColors.blue,
                        ),
                        Container(
                          height: 15,
                          width: double.infinity,
                          color: AppColors.orange,
                        ),
                      ],
                    ),

                    //Boton retroceso
                    Positioned(
                      top: 40,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_sharp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    //Avatar
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            final fotoPerfil = userProvider.usuario?.fotoPerfil;
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.white,
                              backgroundImage:
                                  (fotoPerfil != null && fotoPerfil.isNotEmpty)
                                      ? NetworkImage(fotoPerfil)
                                      : null,
                              child: (fotoPerfil == null || fotoPerfil.isEmpty)
                                  ? const Icon(Icons.person,
                                      size: 90, color: AppColors.white)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),

                    //Botón editar
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 175, right: 0),
                        child: TextButton.icon(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.blue),
                          label: Text('Editar',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.blue)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                //Contenido
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Nombre y apellidos
                      Row(
                        children: [
                          Text(
                            user.nombres,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.blue),
                          ),
                          Text(
                            ' ${user.primerApellido}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.blue),
                          ),
                          Text(
                            ' ${user.segundoApellido}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.blue),
                          ),
                        ],
                      ),

                      //Tipo de usuario
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          user.tipoUsuario,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.blue),
                        ),
                      ),

                      //Calificación promedio
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              'Calificación promedio: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.blue),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user.calificacionPromedio?.toStringAsFixed(1) ??
                                  'Sin calificación',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.orange),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

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
                      // const SizedBox(height: 16),

                      // Sección: Descripción
                      Text(
                        "Descripción",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          user.descripcion?.isNotEmpty == true
                              ? user.descripcion!
                              : "No hay descripción disponible",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.blue),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      const SizedBox(height: 30),
                      Text("Categoría cruda: ${user.idCategoria.toString()}"),

                      // Categorías
                      if (user.idCategoria is List &&
                          user.idCategoria.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Categorías
                            Text(
                              "Categorías",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.blue),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: -4,
                                children: (user.idCategoria as List)
                                    .map<Widget>((tag) {
                                  String nombre;

                                  if (tag is String) {
                                    nombre = tag;
                                  } else if (tag is Map &&
                                      tag.containsKey('nombre_cat')) {
                                    nombre = tag['nombre_cat'].toString();
                                  } else {
                                    nombre = tag.toString();
                                  }

                                  return Chip(
                                    label: Text(
                                      nombre,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.blue),
                                    ),
                                    backgroundColor: AppColors.white,
                                    side: BorderSide(
                                        color: AppColors.blue, width: 1.2),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),

                      //Estadísticas
                      Text(
                        "Estadísticas",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.blue),
                      ),

                      if (user.tipoUsuario == 'trabajador') ...[
                        ListTile(
                          title: Text(
                            "Publicaciones en las que te has postulado",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.blue),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PublicacionesScreen()),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Trabajos completados",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.blue),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              (user.trabajosCompletados ?? 0).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.blue),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Total ganado",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.blue),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              user.tipoUsuario,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.blue),
                            ),
                          ),
                        ),
                      ],

                      ListTile(
                        title: Text(
                          "Miembro desde",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: AppColors.blue),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            formatDate(user.fechaRegistro),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Insignias
                      Text(
                        "Insignias",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "Las insignias son un modo de reconocer los logros de los usuarios. Otros usuarios podrán verlas. Será una función que agregaremos próximamente ;)",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.blue),
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

//Wdgt para el correo numero ubicacion
  Widget _buildInfoSection({
    required String title,
    required String content,
  }) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              content,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.blue,
                  ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  //Formato de fecha
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('d MMMM y', 'es').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
