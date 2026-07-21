import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumber;
  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
    this.label,
    this.controller, {
    super.key,
    this.isNumber = false,
    this.icon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: inputFormatters,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
        prefixIcon: icon != null
            ? Icon(icon, size: 18.r, color: AppColors.slateGrey)
            : null,
        filled: true,
        fillColor: AppColors.blue.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              width: 1.r, color: AppColors.slateGrey.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1.6.r, color: AppColors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 14.w,
        ),
      ),
    );
  }
}
