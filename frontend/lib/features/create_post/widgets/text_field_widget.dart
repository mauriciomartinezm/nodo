import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumber;

  const CustomTextField(
    this.label,
    this.controller, {
    super.key,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: AppTypography.body,
        decoration: InputDecoration(
          labelText: label,
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
      ),
    );
  }
}