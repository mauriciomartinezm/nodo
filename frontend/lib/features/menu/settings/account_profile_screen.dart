import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  String phone = '0000000000';
  String email = 'user@mail.com';

    @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta y perfil',
            style: 
                AppTypography.h1.copyWith(color: AppColors.blue)),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text('Editar Perfil',
                  style:
                      AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/editProfile');
              },
            ),
            ListTile(
              title: Text('Cambiar contraseña',
                  style:
                      AppTypography.h2.copyWith(color: AppColors.blue)),
              onTap: _changePassword,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _deleteModal,
              child:  Text('Eliminar cuenta',
                  style: AppTypography.h2.copyWith(color: AppColors.orange)),
            ),
          ],
        ),
      ),
    );
  }

  //Cambiar contraseña
  void _changePassword() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: const Color.fromARGB(150, 6, 54, 102),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Cambiar Contraseña',
            style: AppTypography.h1.copyWith(color: AppColors.blue),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                //Contraseña actual
                TextField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña actual',
                    labelStyle:
                        AppTypography.body.copyWith(color: AppColors.blue),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),

                //Nueva contraseña
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña nueva',
                    labelStyle:
                        AppTypography.body.copyWith(color: AppColors.blue),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),

                //Confirmar contraseña
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña nueva',
                    labelStyle:
                        AppTypography.body.copyWith(color: AppColors.blue),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: AppTypography.h3.copyWith(color: AppColors.blue)),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Las contraseñas no coinciden',
                          style: AppTypography.h3
                              .copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                //Aquí iría la lógica real para actualizar la contraseña

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contraseña actualizada',
                        style: AppTypography.h3
                            .copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,),
                            backgroundColor: AppColors.blue,

                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
              ),
              child: Text('Actualizar', style: AppTypography.h2),
            ),
          ],
        );
      },
    );
  }


  void _deleteModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Eliminar Cuenta',
                    style: AppTypography.h1.copyWith(color: AppColors.orange)),
                const SizedBox(height: 5),
                Text('¿Estás seguro de que deseas eliminar tu cuenta?',
                    style: AppTypography.body.copyWith(color: AppColors.blue)),
                const SizedBox(height: 10),
                Text(
                  'Eliminar tu cuenta es una acción PERMANENTE. Perderás el acceso a tu perfil, publicaciones,historial de trabajos, calificaciones y cualquier otro dato asociado a tu cuenta en NODO',
                  style: AppTypography.body.copyWith(
                    color: AppColors.blue,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Eliminar mi cuenta de NODO'),
                ),
              ],
            ),
          );
        },
      );
    }
}

