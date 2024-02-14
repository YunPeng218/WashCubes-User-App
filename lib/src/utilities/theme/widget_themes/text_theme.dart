import 'package:device_run_test/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme createTextTheme(Color color) {
    return TextTheme(
      displayLarge: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 26,
      ),
      displayMedium: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 19,
      ),
      displaySmall: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      headlineLarge: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      headlineMedium: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      headlineSmall: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
      labelLarge: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      labelMedium: GoogleFonts.lexend(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
    );
  }

  static TextTheme blackTextTheme = createTextTheme(const Color(0xFF1C1C28));
  static TextTheme blueTextTheme = createTextTheme(AppColors.cBlueColor3);
  static TextTheme greyTextTheme = createTextTheme(AppColors.cGreyColor3);
  static TextTheme whiteTextTheme = createTextTheme(Colors.white);
  static TextTheme redTextTheme = createTextTheme(Colors.red);
  static TextTheme greenTextTheme = createTextTheme(Colors.green);
}
