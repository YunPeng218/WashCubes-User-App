import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w500, 
      fontSize: 26,
    ),
    displayMedium: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w500, 
      fontSize: 19,
    ),
    displaySmall: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w500, 
      fontSize: 18,
    ),
    headlineLarge: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w500, 
      fontSize: 16,
    ),
    headlineMedium: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w500, 
      fontSize: 14,
    ),
    headlineSmall: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w400, 
      fontSize: 13,
    ),
    labelLarge: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w400, 
      fontSize: 11,
    ),
    labelMedium: GoogleFonts.lexend(
      color: const Color.fromRGBO(28, 28, 40, 1), 
      fontWeight: FontWeight.w400, 
      fontSize: 10,
    ),
  );
}