import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Map<String, String>> categories;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
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
        initialValue: value,
        style: AppTypography.body,
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down),
        items: categories.map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem<String>(
            value: category['nombre'],
            child: Text(
              category['nombre']!,
              style: AppTypography.label.copyWith(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
