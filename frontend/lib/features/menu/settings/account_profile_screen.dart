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
              onTap: _changePasswordModal,
            ),
            ListTile(
              title: Text('Número de teléfono y correo electrónico',
                  style:
                      AppTypography.h2.copyWith(color: AppColors.blue)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phone,
                      style: 
                          AppTypography.body.copyWith(color: AppColors.blue)),
                  Text(email,
                      style:
                          AppTypography.body.copyWith(color: AppColors.blue)),
                ],
              ),
              onTap: _editContactInfo,
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

  void _changePasswordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: AppColors.orange,
      barrierColor: const Color.fromARGB(70, 6, 54, 102),
      builder: (_) {
        final TextEditingController passwordController =
            TextEditingController();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text('Cambiar Contraseña',
                  style: AppTypography.h1.copyWith(color: AppColors.blue,)),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration:
                     InputDecoration(labelText: 'Nueva contraseña',
                    labelStyle: AppTypography.body.copyWith(
                      color: AppColors.blue,
                    )),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contraseña actualizada', style: AppTypography.body.copyWith(
                      color: AppColors.white,
                        )
                      ),
                      backgroundColor: AppColors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.white,
                ),
                child: Text('Actualizar',
                    style: AppTypography.h2
                    ),
              ),
            ],
          ),
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

  void _editContactInfo() {
    final phoneController = TextEditingController(text: phone);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(180, 6, 54, 102),
      builder: (_) => AlertDialog(
        title:  Text('Editar nombre y/o correo', style: AppTypography.h1.copyWith(
                      color: AppColors.orange,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Teléfono',
                    labelStyle: AppTypography.h2.copyWith(
                      color: AppColors.blue,
                    ))),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo',
                    labelStyle: AppTypography.h2.copyWith(
                      color: AppColors.blue,
                    ))),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: AppTypography.body.copyWith(
                    color: AppColors.blue,
                  ))),
          ElevatedButton(
            onPressed: () {
              setState(() {
                phone = phoneController.text;
                email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Guardar',
              style: AppTypography.h2.copyWith(
                color: AppColors.blue,
              )
            ),
          ),
        ],
      ),
    );
  }
}

