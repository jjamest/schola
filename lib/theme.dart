import 'package:flutter/material.dart';

class ScholaTheme {
  ScholaTheme._();

  static const Color deepBlack = Color(0xFF0A0A0A);
  static const Color darkGray = Color(0xFF1C1C1E);
  static const Color mediumGray = Color(0xFF2C2C2E);
  static const Color lightGray = Color(0xFF8E8E93);
  static const Color accentBlue = Color(0xFF007AFF);
  static const Color accentWhite = Color(0xFFF5F5F7);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: accentBlue,
    scaffoldBackgroundColor: deepBlack,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      secondary: accentWhite,
      surface: darkGray,
      error: Color(0xFFFF3B30),
      onPrimary: accentWhite,
      onSecondary: deepBlack,
      onSurface: accentWhite,
      onError: accentWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: deepBlack,
      foregroundColor: accentWhite,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: accentWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: accentWhite,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
      ),
      displayMedium: TextStyle(
        color: accentWhite,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: lightGray,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        color: accentWhite,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: accentBlue,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: accentWhite,
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: lightGray,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: accentBlue,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentBlue,
        foregroundColor: accentWhite,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentBlue,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentBlue,
      foregroundColor: accentWhite,
      shape: CircleBorder(),
    ),
    cardTheme: const CardTheme(
      color: darkGray,
      elevation: 0,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: mediumGray, thickness: 0.5),
    iconTheme: const IconThemeData(color: accentWhite, size: 24),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: mediumGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: lightGray, fontSize: 17),
      hintStyle: const TextStyle(color: lightGray, fontSize: 17),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: darkGray,
      contentTextStyle: TextStyle(color: accentWhite, fontSize: 15),
      actionTextColor: accentBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        color: accentWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(color: accentWhite, fontSize: 17),
    ),
  );
}
