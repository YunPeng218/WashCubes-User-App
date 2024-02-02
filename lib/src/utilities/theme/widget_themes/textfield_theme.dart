import 'package:flutter/material.dart';
import 'package:device_run_test/src/constants/colors.dart';

class CTextFormFieldTheme {
  CTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = 
    const InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: AppColors.cGreyColor3),
      hintStyle: TextStyle(color: AppColors.cGreyColor3),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: AppColors.cBlueColor2)
      )
    );
}