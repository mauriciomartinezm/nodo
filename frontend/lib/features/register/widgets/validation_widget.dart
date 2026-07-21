import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:nodo/features/register/logic/validation_controller.dart';
// import 'package:nodo/features/register/widgets/profile_picture_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ValidationWidget extends StatefulWidget {
  final VoidCallback onContinue;
  const ValidationWidget({super.key, required this.onContinue});

  @override
  State<ValidationWidget> createState() => _ValidationWidgetState();
}

class _ValidationWidgetState extends State<ValidationWidget> {
  @override
  void dispose() {
    context.read<ValidationController>().disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ValidationController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.1 : 16.0;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verificación de identidad',
                style: AppTypography.title.copyWith(color: AppColors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'Hemos enviado un código de 6 dígitos a tu correo electrónico. Ingrésalo a continuación.',
                style: AppTypography.label.copyWith(color: AppColors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // 🔹 Campos de código
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45.w,
                    height: 55.h,
                    child: TextField(
                      controller: controller.controllers[index],
                      focusNode: controller.focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTypography.title,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      onChanged: (value) => controller.onChanged(value, index),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: screenWidth * 0.85,
                child: CustomElevatedButton(
                  text: "Verificar",
                  onPressed: () {
                    final code = controller.getEnteredCode();
                    if (code.length == 6) {
                      widget.onContinue();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Por favor, completa los 6 dígitos.')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '¿No recibiste el código? ',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    TextSpan(
                      text: 'Reenviar',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.orange,
                      ),
                      recognizer: controller.canResend
                          ? (TapGestureRecognizer()
                            ..onTap = () {
                              controller.startCountdown();
                              ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Código reenviado')),
                      );
                            })
                          : null, // 🔹 desactiva el gesto si aún no se puede reenviar
                    ),
                    if (!controller.canResend)
                      TextSpan(
                        text: ' en ${controller.secondsRemaining}s',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
