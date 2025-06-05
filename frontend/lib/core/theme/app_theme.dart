// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color orange = Color(0xFFE9771F);
  static const Color blue = Color(0xFF063666);
  static const Color white = Color(0xffFFFFFF);
  static const Color whiteT = Color.fromARGB(117, 255, 255, 255);
}

class AppTypography {
  static const TextStyle h1 = TextStyle(
    fontFamily: 'GothamMedium',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'GothamMedium',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 14.2,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'GothamBook',
    fontSize: 12,
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