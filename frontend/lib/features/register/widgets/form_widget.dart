import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/register/logic/register_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';

class FormWidget extends StatefulWidget {
  final VoidCallback onContinue; // 🔹 callback para avanzar al siguiente paso

  const FormWidget({super.key, required this.onContinue});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  String? selectedUserType;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastName1Controller = TextEditingController();
  final TextEditingController lastName2Controller = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerController = Provider.of<RegisterController>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldSpacing = 10.h;
    final categorySpacing = 15.h;
    final textSpacing = 5.h;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5.h,
            vertical: 20.h
          ),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texto introductorio
                Text(
                  "En NODO creemos en el poder de unir necesidades con talentos. Regístrate y sé parte de una red que impulsa el trabajo real.",
                  style: AppTypography.h2.copyWith(color: AppColors.blue),
                ),

                SizedBox(height: categorySpacing),

                Text(
                  "¿Cómo quieres comenzar en Nodo?",
                  style: AppTypography.h2.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: textSpacing),

                Text(
                  "Elige si deseas buscar servicios como cliente o empezar a trabajar ofreciendo tu talento.",
                  style: AppTypography.h3.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: textSpacing),

                Text(
                  "Podrás cambiar de rol más adelante si lo deseas.",
                  style: AppTypography.body.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: fieldSpacing),

                // Selector de tipo de usuario
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: "Tipo de usuario"),
                  value: selectedUserType,
                  items: const [
                    DropdownMenuItem(value: "cliente", child: Text("Cliente")),
                    DropdownMenuItem(
                        value: "trabajador", child: Text("Trabajador")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUserType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),

                SizedBox(height: categorySpacing),

                // Información básica
                Text(
                  "Información básica",
                  style: AppTypography.h2.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: fieldSpacing),

                TextFormField(
                  decoration: const InputDecoration(labelText: "Nombre(s)"),
                  controller: nameController,
                  //widthPercentage: 0.85,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$")
                        .hasMatch(value)) {
                      return 'Solo se permiten letras';
                    }
                    return null;
                  },
                ),
                SizedBox(height: fieldSpacing),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Primer apellido"),
                  controller: lastName1Controller,
                  //widthPercentage: 0.85,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$")
                        .hasMatch(value)) {
                      return 'Solo se permiten letras';
                    }
                    return null;
                  },
                ),
                SizedBox(height: fieldSpacing),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Segundo apellido"),
                  controller: lastName2Controller,
                  //widthPercentage: 0.85,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$")
                        .hasMatch(value)) {
                      return 'Solo se permiten letras';
                    }
                    return null;
                  },
                ),
                SizedBox(height: fieldSpacing),
                TextFormField(
                  //label: 'Cédula',
                  controller: idController,
                  //widthPercentage: 0.85,
                  decoration: const InputDecoration(labelText: "Cédula"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (!RegExp(r"^\d{1,10}$").hasMatch(value)) {
                      return 'Debe contener solo números (máx. 10 dígitos)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: categorySpacing),

                // Datos de contacto
                Text(
                  "Datos de contacto y seguridad",
                  style: AppTypography.h2.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: fieldSpacing),

                TextFormField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(labelText: "Número telefónico"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (!RegExp(r"^\d{1,10}$").hasMatch(value)) {
                      return 'Debe contener solo números (máx. 10 dígitos)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: fieldSpacing),

                // Campo de fecha integrado en el Form para que su validator funcione
                FormField<DateTime>(
                  validator: (value) {
                    if (value == null) return 'Por favor selecciona una fecha';
                    return null;
                  },
                  builder: (field) {
                    final isEmpty = field.value == null;
                    final effectiveLabel = 'Fecha de nacimiento';

                    return GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: field.context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          field.didChange(picked); // actualiza el valor
                        }
                      },
                      child: InputDecorator(
                        isEmpty: isEmpty,
                        decoration: InputDecoration(
                          labelText: effectiveLabel,
                          errorText: field.errorText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEmpty
                              ? ''
                              : DateFormat('dd/MM/yyyy').format(field.value!),
                          style: TextStyle(
                            color: isEmpty ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: categorySpacing),

                // Datos adicionales (solo si es trabajador)
                if (selectedUserType == "trabajador") ...[
                  Text(
                    "Datos adicionales",
                    style: AppTypography.h2.copyWith(color: AppColors.blue),
                  ),
                  SizedBox(height: fieldSpacing),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                        labelText: "Ubicación o zona de servicio"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: fieldSpacing),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        labelText: "Descripción breve de los servicios"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                    maxLines: 3,
                  ),
                  SizedBox(height: categorySpacing),
                ],

                // Crear contraseña
                Text(
                  "Crea una contraseña",
                  style: AppTypography.h2.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: textSpacing),

                Text(
                  "Crea una contraseña segura para proteger tu cuenta. Debe tener mínimo 8 caracteres, combinar letras mayúsculas, minúsculas, números y símbolos.",
                  style: AppTypography.body.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: fieldSpacing),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: fieldSpacing),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirma tu contraseña"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (value != passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                SizedBox(height: categorySpacing*2),
                CustomElevatedButton(
                  text: "Continuar",
                  onPressed: registerController.isLoading
                      ? null
                      : () async {
                          await registerController.registerUser(
                            context: context,
                            formKey: _formKey,
                            nameController: nameController,
                            lastName1Controller: lastName1Controller,
                            lastName2Controller: lastName2Controller,
                            idController: idController,
                            passwordController: passwordController,
                            confirmPasswordController:
                                confirmPasswordController,
                            selectedUserType: selectedUserType,
                            onContinue: widget.onContinue,
                          );
                        },
                  loading: registerController.isLoading,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
