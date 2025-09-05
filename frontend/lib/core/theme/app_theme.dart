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
  //ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(0),
        ),
      ),
      textStyle: AppTypography.h2,
    ),
  ),
);