import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class CategoriaDropdown extends StatelessWidget {
  final List<Map<String, String>> categorias;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoriaDropdown({
    super.key,
    required this.categorias,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Categoría",
        labelStyle: TextStyle(
          fontSize: 9.sp,
          color: AppColors.aux,
          fontFamily: "GothamBook",
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 10.w,
        ),
      ),
      value: value,
      items: categorias.map<DropdownMenuItem<String>>((categoria) {
        return DropdownMenuItem<String>(
          value: categoria['nombre'],
          child: Text(categoria['nombre']!),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}