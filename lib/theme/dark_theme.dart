import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFFffbd5c),
  secondaryHeaderColor: const Color(0xFF009f67),
  disabledColor: const Color(0xFF6f7275),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFFffbd5c))), colorScheme: const ColorScheme.dark(primary: Color(0xFFffbd5c), secondary: Color(0xFFffbd5c)).copyWith(error: const Color(0xFFdd3135)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
  bottomAppBarTheme: const BottomAppBarTheme(
    surfaceTintColor: Colors.black, height: 60,
    padding: EdgeInsets.symmetric(vertical: 5),
  ),
  dividerTheme: const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
);
