import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:nodo/features/register/logic/profile_picture_controller.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfilePictureController>(context);
    final isWorker = Provider.of<UserProvider>(context).isWorker;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 🔹 Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Personalización y Configuración',
            style: AppTypography.title.copyWith(color: AppColors.blue),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            'Tu foto de perfil es importante para generar confianza con los clientes.'
            'Asegúrate de subir una imagen clara y profesional.',
            style: AppTypography.label
                .copyWith(color: AppColors.blue, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: controller.pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: controller.imageFile != null
                      ? FileImage(controller.imageFile!)
                      : const AssetImage('assets/icons/iconNodoBlue.png')
                          as ImageProvider,
                  backgroundColor: Colors.grey.shade400.withOpacity(0.4),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit,
                        size: 18, color: Colors.orange.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: controller.acceptedTerms,
                onChanged: controller.toggleAccepted,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14),
                    children: [
                      TextSpan(
                          text: 'Acepto los ',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.blue,
                          )),
                      TextSpan(
                        text: 'Términos y Condiciones',
                        style: AppTypography.caption.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Términos y Condiciones')),
                            );
                          },
                      ),
                      TextSpan(
                          text: ' y la ',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.blue,
                          )),
                      TextSpan(
                        text: 'Política de Privacidad',
                        style: AppTypography.caption.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Política de Privacidad')),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            text: 'Crear cuenta',
            onPressed: controller.acceptedTerms && !controller.isLoading
                ? () async {
                    final success = await controller.confirm(context);
                    if (success && context.mounted) {
                      onContinue();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Hubo un problema al subir la imagen.')),
                      );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
