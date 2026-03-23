import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF6A0DAD);
  static const Color _secondary = Color(0xFFB388FF);
  static const Color _background = Color(0xFF1A0A2E);
  static const Color _surface = Color(0xFF2D1B4E);
  static const Color _onSurface = Color(0xFFE8D5FF);
  static const Color _accent = Color(0xFFFFD700);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          onSurface: _onSurface,
          tertiary: _accent,
        ),
        scaffoldBackgroundColor: _background,
        appBarTheme: const AppBarTheme(
          backgroundColor: _background,
          foregroundColor: _onSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: _onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        cardTheme: CardThemeData(
          color: _surface,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF5A2D8A), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: _onSurface, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: _onSurface, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: _onSurface, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: _secondary),
          bodyLarge: TextStyle(color: _onSurface),
          bodyMedium: TextStyle(color: Color(0xFFCCAAFF)),
          labelLarge: TextStyle(color: _accent, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: _secondary),
        dividerTheme: const DividerThemeData(color: Color(0xFF3D2060)),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF3D2060),
          labelStyle: const TextStyle(color: _secondary, fontSize: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
}
