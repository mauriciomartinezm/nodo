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
      maxLines: 4,
      minLines: 3,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: "Descripción *",
        alignLabelWithHint: true,
        labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
        // prefixIcon: Padding(
        //   padding: EdgeInsets.only(bottom: 60.h),
        //   child: Icon(Icons.description_outlined,
        //       size: 18.r, color: AppColors.slateGrey),
        // ),
        filled: true,
        fillColor: AppColors.blue.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              width: 1.r, color: AppColors.slateGrey.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1.6.r, color: AppColors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      ),
    );
  }
}
