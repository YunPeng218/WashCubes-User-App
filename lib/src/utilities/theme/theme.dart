import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();//Make constructor private to prevent access from instance
  static ThemeData lightTheme = ThemeData(
    
    // primarySwatch: const MaterialColor(
    //   0xFF88B6F7, <int, Color>{
    //     50 : Color(0xFFFFFFFF),
    //     100 : Color(0xFFD7ECF7),
    //     200 : Color(0xFFA1CCE5),
    //     300 : Color(0xFF88B6F7),
    //     400 : Color(0xFF2A61D2),
    //     500 : Color(0xFF45799F),
    //     600 : Color(0xFF182738),
    //     700 : Color(0xFFEFEFEF),
    //     800 : Color(0xFFBEBEBE),
    //     900 : Color(0xFF8B8B8B),
    //   }
    // ),
    textTheme: CTextTheme.lightTextTheme,
  );
}