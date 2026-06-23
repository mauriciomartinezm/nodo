import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

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
    return SizedBox(
      height: 30.h,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Categoría",
          labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.r, color: AppColors.slateGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.r, color: AppColors.slateGrey),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.w,
          ),
        ),
        value: value,
        style: AppTypography.body,
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down),
        items: categorias.map<DropdownMenuItem<String>>((categoria) {
          return DropdownMenuItem<String>(
            value: categoria['nombre'],
            child: Text(
              categoria['nombre']!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: "GothamBook",
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
