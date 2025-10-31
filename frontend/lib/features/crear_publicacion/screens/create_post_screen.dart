import 'package:flutter/material.dart';
import 'package:nodo/features/crear_publicacion/logic/crear_publicacion_controller.dart';
import 'package:nodo/features/crear_publicacion/widgets/date_picker_widget.dart';
import 'package:nodo/features/crear_publicacion/widgets/descripcion_field_widget.dart';
import 'package:nodo/features/crear_publicacion/widgets/header_info_widget.dart';
import 'package:nodo/providers/categorie_provider.dart';
import 'package:nodo/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/foto_widget.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/text_field_widget.dart';

class CrearPublicacionScreen extends StatefulWidget {
  const CrearPublicacionScreen({super.key});

  @override
  State<CrearPublicacionScreen> createState() => _CrearPublicacionScreenState();
}

class _CrearPublicacionScreenState extends State<CrearPublicacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emptyFocusNode = FocusNode();

  @override
  void dispose() {
    _emptyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CrearPublicacionController>();
    final categorieProvider = context.watch<CategorieProvider>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (categorieProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderInfoWidget(),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      // --- Campos del formulario ---
                      CustomTextField("Título", controller.tituloController),
                      SizedBox(height: 10.h),

                      // --- Categorías dinámicas ---
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: categorieProvider.categories.map((categoria) {
                          final isSelected = controller.selectedCategories
                              .contains(categoria.id);
                          return ChoiceChip(
                            label: Text(
                              categoria.nombre,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.orange,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              side: BorderSide(color: AppColors.orange),
                            ),
                            onSelected: (_) =>
                                controller.toggleCategoria(categoria.id),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.h),

                      CustomTextField("Ubicación", controller.ubicacionController),
                      SizedBox(height: 10.h),

                      CustomTextField("Presupuesto", controller.presupuestoController,
                          isNumber: true),
                      SizedBox(height: 10.h),

                      CustomDatePicker(
                        label: "Fecha límite",
                        controller: controller.fechaLimiteController,
                        initialDate: DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        emptyFocusNode: _emptyFocusNode,
                      ),
                      SizedBox(height: 10.h),

                      DescripcionField(controller: controller.descripcionController),
                      SizedBox(height: 10.h),

                      // --- Subida de fotos ---
                      SubirFotoWidget(
                        key: ValueKey(controller.urlsImagenes),
                        onUploadComplete: controller.setUrlsImagenes,
                        initialUrls: controller.urlsImagenes,
                      ),

                      // --- Mensaje de error ---
                      if (controller.errorMessage != null) ...[
                        SizedBox(height: 10.h),
                        Text(
                          controller.errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],

                      SizedBox(height: 15.h),

                      // --- Botón de enviar ---
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  final success = await controller
                                      .crearPublicacion(context, userProvider);

                                  if (success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "¡Publicación creada con éxito!")),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white)
                              : Text("Publicar",
                                  style: AppTypography.h2
                                      .copyWith(color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
