import 'package:flutter/material.dart';
import 'package:nodo/features/create_post/widgets/date_picker_widget.dart';
import 'package:nodo/features/create_post/widgets/descripcion_field_widget.dart';
import 'package:nodo/features/create_post/widgets/text_field_widget.dart';
import 'package:nodo/features/edit_post/logic/edit_post_controller.dart';
import 'package:nodo/shared/providers/categorie_provider.dart';
import 'package:nodo/shared/providers/location_provider.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:nodo/shared/widgets/multi_select_dropdown.dart';
import 'package:nodo/shared/widgets/searchable_dropdown_field.dart';
import 'package:nodo/shared/widgets/upload_photo_widget.dart';
import 'package:nodo/models/categorie.dart';
import 'package:nodo/models/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emptyFocusNode = FocusNode();

  @override
  void dispose() {
    _emptyFocusNode.dispose();
    super.dispose();
  }

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

  Widget _buildExistingPhotos(List<String> photos) {
    if (photos.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: photos
            .map(
              (url) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  width: 72.w,
                  height: 72.h,
                  fit: BoxFit.cover,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditPostController>();
    final categorieProvider = context.watch<CategorieProvider>();
    final locationProvider = context.watch<LocationProvider>();

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
        iconTheme: const IconThemeData(color: AppColors.blue),
        title: Text(
          "Editar publicación",
          style: AppTypography.title.copyWith(color: AppColors.orange),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        emptyFocusNode: _emptyFocusNode,
                      ),
                      SizedBox(height: 12.h),
                      DescripcionField(
                          controller: controller.descripcionController),
                      SizedBox(height: 20.h),
                      _sectionLabel(
                          Icons.photo_library_outlined, "Fotos"),
                      _buildExistingPhotos(controller.existingPhotos),
                      UploadPhotoWidget(
                        key: ValueKey(controller.newLocalImages),
                        onImagesSelected: controller.setNewLocalImages,
                        initialImages: controller.newLocalImages,
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
                          text: "Guardar cambios",
                          icon: Icons.save_outlined,
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  final success =
                                      await controller.saveChanges(context);
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Publicación actualizada correctamente')),
                                    );
                                    Navigator.pop(context);
                                  }
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
