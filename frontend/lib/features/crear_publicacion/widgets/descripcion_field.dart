import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class DescripcionField extends StatelessWidget {
  final TextEditingController controller;

  const DescripcionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: "Descripción",
        alignLabelWithHint: true,
        labelStyle: AppTypography.body.copyWith(color: AppColors.whiteT),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
        ),
      ),
    );
  }
}