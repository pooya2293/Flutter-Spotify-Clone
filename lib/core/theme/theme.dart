import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Palette.borderColor, width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Palette.gradient2, width: 3),
      ),
    ),
  );
}
