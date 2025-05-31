import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class SubirFotoWidget extends StatefulWidget {
  const SubirFotoWidget({super.key});

  @override
  State<SubirFotoWidget> createState() => _SubirFotoWidgetState();
}

class _SubirFotoWidgetState extends State<SubirFotoWidget> {
  List<String> _imagenes = [];

  Future<void> _seleccionarImagen() async {
    // Implementa la lógica para seleccionar imágenes
    // Esto es un placeholder - deberías integrar con image_picker o similar
    setState(() {
      _imagenes.add('nueva_imagen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos del trabajo',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.primaryColor,
            fontFamily: 'GothamMedium',
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            ..._imagenes.map((img) => _buildImagePreview(img)).toList(),
            _buildAddButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(String image) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor.withOpacity(0.1),
        image: DecorationImage(
          image: AssetImage(
              'assets/images/diomedes_joven.jpg'), // Reemplaza con tu imagen real
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _seleccionarImagen,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor.withOpacity(0.1),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.r,
          ),
        ),
        child: Center(
          // Widget Center agregado aquí
          child: Icon(
            Icons.add,
            size: 30.r,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
