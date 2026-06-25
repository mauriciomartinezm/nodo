// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color orange = Color(0xFFE9771F);
  static const Color blue = Color(0xFF063666);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color slateGrey = Color.fromARGB(255, 144, 158, 168);
  static const Color transparent = Colors.transparent;

  // Semánticos
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
}

class AppTypography {
  static TextStyle title = const TextStyle(
    fontFamily: 'GothamBold',
    fontSize: 18,
  );

  static TextStyle subtitle = const TextStyle(
    fontFamily: 'GothamMedium',
    fontSize: 16,
  );

  static TextStyle body = const TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 14,
  );

  static TextStyle label = const TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 13,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 11,
  );
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true, // puedes dejarlo en true si usas M3
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    secondary: AppColors.orange,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white, // color del texto o íconos
      textStyle: AppTypography.subtitle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      minimumSize: Size(double.infinity, 36.h), // alto base del botón
      elevation: 0,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    //filled: true,
    //fillColor: AppColors.slateGrey.withOpacity(0.1), // color de fondo del input
    contentPadding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 14.w),

    labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
    //hintStyle: AppTypography.caption.copyWith(color: AppColors.slateGrey), //no se donde se usa

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.slateGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.blue),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.slateGrey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.error),
    ),
  ),
);
