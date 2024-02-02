import 'package:device_run_test/src/utilities/theme/widget_themes/elevatedbutton_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/textfield_theme.dart';
import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();//Make constructor private to prevent access from instance
  
  static ThemeData lightTheme = ThemeData(
    textTheme: CTextTheme.lightTextTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
  );
}