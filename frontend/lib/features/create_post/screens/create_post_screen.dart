import 'package:flutter/material.dart';
import 'package:nodo/features/create_post/logic/create_post_controller.dart';
import 'package:nodo/features/create_post/widgets/date_picker_widget.dart';
import 'package:nodo/features/create_post/widgets/descripcion_field_widget.dart';
import 'package:nodo/features/create_post/widgets/header_info_widget.dart';
import 'package:nodo/shared/providers/categorie_provider.dart';
import 'package:nodo/shared/providers/location_provider.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:nodo/shared/widgets/multi_select_dropdown.dart';
import 'package:nodo/shared/widgets/searchable_dropdown_field.dart';
import 'package:nodo/models/categorie.dart';
import 'package:nodo/models/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/upload_photo_widget.dart';
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

  // Widget para mostrar la sección con un ícono y un texto
  Widget _sectionLabel(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: AppColors.blue),
          SizedBox(width: 5.w),
          Text(
            text,
            style: AppTypography.label.copyWith(color: AppColors.blue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreatePostController>();
    final categorieProvider = context.watch<CategorieProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final userProvider = context.watch<UserProvider>();
    final fotoPerfil = userProvider.user?.fotoPerfil;

    if (categorieProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          "Crear publicación",
          style: AppTypography.title.copyWith(color: AppColors.orange),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.blue.withValues(alpha: 0.1),
              backgroundImage: fotoPerfil != null && fotoPerfil.isNotEmpty
                  ? NetworkImage(fotoPerfil)
                  : null,
              child: fotoPerfil == null || fotoPerfil.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Image.asset(
                        'assets/icons/iconNodoBlue.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderInfoWidget(), // Muestra el nombre y la profesión del usuario
                SizedBox(height: 16.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.w),
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(Icons.edit_outlined, "¿Qué necesitas?"),
                      CustomTextField(
                        "Título *",
                        controller.tituloController,
                        icon: Icons.title,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Tipo de trabajo *",
                        style:
                            AppTypography.label.copyWith(color: AppColors.blue),
                      ),
                      SizedBox(height: 8.h),
                      MultiSelectDropdown<Categorie>(
                        label: 'Tipo de trabajo',
                        hint: 'Selecciona uno o varios tipos de trabajo',
                        options: categorieProvider.categories,
                        selectedValues: categorieProvider.categories
                            .where((c) => controller.selectedCategories
                                .contains(c.id))
                            .toList(),
                        labelBuilder: (categoria) => categoria.name,
                        onChanged: (selected) => controller
                            .setCategories(selected.map((c) => c.id).toList()),
                      ),
                      SizedBox(height: 20.h),
                      _sectionLabel(
                          Icons.info_outline, "Detalles de la solicitud"),
                      SearchableDropdownField<Location>(
                        label: "Ubicación *",
                        icon: Icons.location_on_outlined,
                        searchHint: "Buscar ubicación...",
                        emptyMessage: "No se encontraron ubicaciones",
                        options: locationProvider.locations,
                        labelBuilder: (location) => location.name,
                        value: locationProvider.locations
                            .cast<Location?>()
                            .firstWhere(
                              (l) =>
                                  l!.name ==
                                  controller.ubicacionController.text,
                              orElse: () => null,
                            ),
                        onChanged: (location) =>
                            controller.setUbicacion(location.name),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        "Presupuesto *",
                        controller.presupuestoController,
                        isNumber: true,
                        icon: Icons.attach_money,
                      ),
                      SizedBox(height: 12.h),
                      CustomDatePicker(
                        label: "Fecha límite *",
                        controller: controller.fechaLimiteController,
                        initialDate:
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        emptyFocusNode: _emptyFocusNode,
                      ),
                      SizedBox(height: 12.h),
                      DescripcionField(
                          controller: controller.descripcionController),
                      SizedBox(height: 20.h),
                      _sectionLabel(
                          Icons.photo_library_outlined, "Fotos (opcional)"),
                      UploadPhotoWidget(
                        key: ValueKey(controller.localImages),
                        onImagesSelected: controller.setLocalImages,
                        initialImages: controller.localImages,
                      ),
                      if (controller.errorMessage != null) ...[
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 16.r, color: AppColors.error),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: AppTypography.caption
                                      .copyWith(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          text: "Publicar",
                          icon: Icons.send_outlined,
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  await controller.createPost(
                                      context, userProvider);
                                },
                          loading: controller.isLoading,
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
