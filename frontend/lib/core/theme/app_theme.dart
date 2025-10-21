// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color orange = Color(0xFFE9771F);
  static const Color blue = Color(0xFF063666);
  static const Color white = Color(0xffFFFFFF);
  //static const Color whiteT = Color.fromARGB(117, 255, 255, 255);
  static const Color whiteT = Color.fromARGB(255, 144, 158, 168);

}

class AppTypography {
  static TextStyle h1 = TextStyle(
    fontFamily: 'GothamMedium',
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: 'GothamMedium',
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle body = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 14.2.sp,
  );

  static TextStyle body2 = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 12.sp,
  );
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true, // puedes dejarlo en true si usas M3
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white, // color del texto o íconos
      textStyle: AppTypography.h2.copyWith(
        //fontFamily: "GothamMedium",
        fontSize: 12.sp,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      minimumSize: Size(double.infinity, 36.h), // alto base del botón
      elevation: 0,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    //filled: true,
    //fillColor: AppColors.whiteT.withOpacity(0.1), // color de fondo del input
    contentPadding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 14.w),

    labelStyle: AppTypography.body.copyWith(color: AppColors.whiteT),
    //hintStyle: AppTypography.body2.copyWith(color: AppColors.whiteT), //no se donde se usa

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.blue, width: 1), // borde por defecto, no hace ningun cambio
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.whiteT, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.blue, width: 2),
    ),
  ),
);