import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

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
        style: TextStyle(
          fontSize: 9.sp,
          color: Colors.black,
          fontFamily: "GothamBook",
        ),
        decoration: InputDecoration(
          labelText: label,
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
      ),
    );
  }
}