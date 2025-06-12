import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color orange = Color(0xFFE9771F);
  static const Color blue = Color(0xFF063666);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteT = Color.fromARGB(255, 144, 158, 168);
}

class AppTypography {
  static TextStyle get h1 => TextStyle(
        fontFamily: 'GothamMedium',
        fontSize: (20*0.8).sp,
        // fontWeight: FontWeight.bold,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: 'GothamMedium',
        fontSize: (16 * 0.8).sp,
        // fontWeight: FontWeight.bold,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: 'GothamBook',
        fontSize: (15 * 0.8).sp,
        // fontWeight: FontWeight.bold,
      );

  static TextStyle get body => TextStyle(
        fontFamily: 'GothamBook',
        fontSize: (14.2 * 0.8).sp,
        
      );

  static TextStyle get body2 => TextStyle(
        fontFamily: 'GothamBook',
        fontSize: (12 * 0.8).sp,
      );
}

final ThemeData appTheme = ThemeData(
  textTheme: TextTheme(
    headlineLarge: AppTypography.h1,
    headlineMedium: AppTypography.h2,
    headlineSmall: AppTypography.h3,
    bodyLarge: AppTypography.body,
    bodyMedium: AppTypography.body2,
  ),
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

