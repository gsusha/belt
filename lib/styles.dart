import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData theme(bool isDark) => ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: red,
        scaffoldBackgroundColor: isDark ? bgDark : bgLight,
        iconTheme: const IconThemeData(color: greyLight),
        textTheme: GoogleFonts.robotoTextTheme().apply(
          displayColor: textDark,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(color: isDark ? textDark : textLight),
          iconTheme: const IconThemeData(color: greyLight),
        ),
      );

  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    {
      50: Color(0xFFFEE8E8),
      100: Color(0xFFFBC6C6),
      200: Color(0xFFF9A0A0),
      300: Color(0xFFF7797A),
      400: Color(0xFFF55D5E),
      500: Color(_redPrimaryValue),
      600: Color(0xFFF13A3B),
      700: Color(0xFFEF3232),
      800: Color(0xFFED2A2A),
      900: Color(0xFFEA1C1C),
    },
  );
  static const int _redPrimaryValue = 0xFFF34041;

  static const MaterialColor redAccent = MaterialColor(
    _redAccentValue,
    {
      100: Color(0xFFFFFFFF),
      200: Color(_redAccentValue),
      400: Color(0xFFFFB8B8),
      700: Color(0xFFFF9F9F),
    },
  );
  static const int _redAccentValue = 0xFFFFEBEB;

  static const bgLight = Color(0xFF191B22);
  static const bgDark = Color(0xFFFFFFFF);

  static const textLight = Color(0xFFD9D9D9);
  static const textDark = Color(0xFF191B22);

  static const greyLight = Color(0xFF8D8E90);
  static const greyDark = Color(0xFF4A494E);
}
