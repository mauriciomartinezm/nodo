import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final FocusNode emptyFocusNode;
  const CustomDatePicker({
    super.key,
    required this.label,
    required this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.emptyFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: GestureDetector(
        onTap: () async {
          //FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(emptyFocusNode);
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: firstDate ?? DateTime.now(),
            lastDate: lastDate ?? DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  // Estilo del calendario
                  colorScheme: ColorScheme.light(
                    primary: AppColors.whiteT, // Color del header
                    onPrimary: Colors.white, // Texto del header
                    onSurface: Colors.black, // Texto de los días
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.whiteT, // Botones de acción
                    ),
                  ),
                  // Estilo del campo de fecha
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: AppTypography.body.copyWith(color: AppColors.whiteT),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 10.w,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            final formattedDate =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            controller.text = formattedDate;
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            style: AppTypography.body,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: AppTypography.body.copyWith(color: AppColors.whiteT),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2.r, color: AppColors.whiteT),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 6.h,
                horizontal: 10.w,
              ),
              suffixIcon: Icon(
                Icons.calendar_today,
                size: 16.r,
                color: AppColors.whiteT,
              ),
            ),
          ),
        ),
      ),
    );
  }
}