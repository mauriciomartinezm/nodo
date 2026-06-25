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
    return GestureDetector(
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
                  primary:
                      AppColors.blue, // Color del header y día seleccionado
                  onPrimary: Colors.white, // Texto del header
                  onSurface: Colors.black, // Texto de los días
                  secondary: AppColors.orange,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.blue, // Botones de acción
                  ),
                ),
                // Estilo del campo de fecha
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle:
                      AppTypography.body.copyWith(color: AppColors.slateGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        width: 1.r,
                        color: AppColors.slateGrey.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        width: 1.r,
                        color: AppColors.slateGrey.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 1.6.r, color: AppColors.blue),
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
            labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              size: 18.r,
              color: AppColors.slateGrey,
            ),
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
        ),
      ),
    );
  }
}
