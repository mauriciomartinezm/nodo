import 'package:flutter/material.dart';
import 'package:nodo/features/create_post/logic/create_post_controller.dart';
import 'package:nodo/features/create_post/widgets/date_picker_widget.dart';
import 'package:nodo/features/create_post/widgets/descripcion_field_widget.dart';
import 'package:nodo/features/create_post/widgets/header_info_widget.dart';
import 'package:nodo/shared/providers/categorie_provider.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/foto_widget.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/text_field_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emptyFocusNode = FocusNode();

  @override
  void dispose() {
    _emptyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreatePostController>();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField("Título", controller.tituloController),
                      SizedBox(height: 10.h),
                      Text(
                        "Seleccione la(s) categoría(s) de su servicio",
                        style: AppTypography.label.copyWith(color: AppColors.blue),
                      ),
                      Wrap(
                        spacing: 8.w,
                        children: categorieProvider.categories.map((categoria) {
                          final isSelected = controller.selectedCategories
                              .contains(categoria.id);
                          return ChoiceChip(
                            label: Text(
                              categoria.nombre,
                              style: AppTypography.body.copyWith(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.blue,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.blue,
                            checkmarkColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              side: BorderSide(color: AppColors.blue),
                            ),
                            onSelected: (_) =>
                                controller.toggleCategory(categoria.id),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.h),

                      CustomTextField(
                          "Ubicación", controller.ubicacionController),
                      SizedBox(height: 10.h),

                      CustomTextField(
                          "Presupuesto", controller.presupuestoController,
                          isNumber: true),
                      SizedBox(height: 10.h),

                      CustomDatePicker(
                        label: "Fecha límite",
                        controller: controller.fechaLimiteController,
                        initialDate:
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        emptyFocusNode: _emptyFocusNode,
                      ),
                      SizedBox(height: 10.h),

                      DescripcionField(
                          controller: controller.descripcionController),
                      SizedBox(height: 10.h),

                      // --- Subida de fotos (locales) ---
                      UploadPhotoWidget(
                        key: ValueKey(controller.localImages),
                        onImagesSelected: controller.setLocalImages,
                        initialImages: controller.localImages,
                      ),

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

                      CustomElevatedButton(
                        text: "Publicar",
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                await controller
                                    .createPost(context, userProvider);
                              },
                        loading: controller.isLoading,
                      )
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
