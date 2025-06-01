import 'package:flutter/material.dart';

class AppTheme {
  // Classic Industrial / Dependable Palette
  static final Color _lightPrimaryColor = Color(0xFF003366); // Navy
  static final Color _lightSecondaryColor = Color(0xFFFF9900); // Industrial Orange
  static final Color _lightBackgroundColor = Color(0xFFF5F5F5); // Light Gray
  static final Color _lightSurfaceColor = Color(0xFFFFFFFF); // White
  static final Color _lightErrorColor = Color(0xFFB00020);
  static final Color _lightOnPrimaryColor = Color(0xFFFFFFFF);
  static final Color _lightOnSecondaryColor = Color(0xFF000000);
  static final Color _lightOnSurfaceColor = Color(0xFF212121); // Dark Gray
  static final Color _lightOnBackgroundColor = Color(0xFF212121); // Dark Gray
  static final Color _lightOnErrorColor = Color(0xFFFFFFFF);

  static final Color _darkPrimaryColor = Color(0xFF7986CB); // Lighter/Desaturated Navy for Dark Mode
  static final Color _darkSecondaryColor = Color(0xFFFF9900); // Industrial Orange
  static final Color _darkBackgroundColor = Color(0xFF121212); // Near Black
  static final Color _darkSurfaceColor = Color(0xFF1E1E1E); // Dark Gray
  static final Color _darkErrorColor = Color(0xFFCF6679); // Lighter Red for Dark Mode
  static final Color _darkOnPrimaryColor = Color(0xFFFFFFFF);
  static final Color _darkOnSecondaryColor = Color(0xFF000000);
  static final Color _darkOnSurfaceColor = Color(0xFFE0E0E0); // Light Gray/Off-White
  static final Color _darkOnBackgroundColor = Color(0xFFE0E0E0); // Light Gray/Off-White
  static final Color _darkOnErrorColor = Color(0xFF000000);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _lightPrimaryColor,
      colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        surface: _lightSurfaceColor,
        background: _lightBackgroundColor,
        error: _lightErrorColor,
        onPrimary: _lightOnPrimaryColor,
        onSecondary: _lightOnSecondaryColor,
        onSurface: _lightOnSurfaceColor,
        onBackground: _lightOnBackgroundColor,
        onError: _lightOnErrorColor,
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightPrimaryColor.withOpacity(0.9),
        iconTheme: IconThemeData(color: _lightOnPrimaryColor),
        actionsIconTheme: IconThemeData(color: _lightOnPrimaryColor),
        titleTextStyle: TextStyle(
          color: _lightOnPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurfaceColor.withOpacity(0.9),
        selectedItemColor: _lightPrimaryColor,
        unselectedItemColor: _lightOnSurfaceColor.withOpacity(0.7),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightSecondaryColor,
          foregroundColor: _lightOnSecondaryColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightSecondaryColor,
        foregroundColor: _lightOnSecondaryColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        surface: _darkSurfaceColor,
        background: _darkBackgroundColor,
        error: _darkErrorColor,
        onPrimary: _darkOnPrimaryColor,
        onSecondary: _darkOnSecondaryColor,
        onSurface: _darkOnSurfaceColor,
        onBackground: _darkOnBackgroundColor,
        onError: _darkOnErrorColor,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurfaceColor.withOpacity(0.9),
        iconTheme: IconThemeData(color: _darkOnSurfaceColor),
        actionsIconTheme: IconThemeData(color: _darkOnSurfaceColor),
        titleTextStyle: TextStyle(
          color: _darkOnSurfaceColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurfaceColor.withOpacity(0.9),
        selectedItemColor: _darkSecondaryColor,
        unselectedItemColor: _darkOnSurfaceColor.withOpacity(0.7),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkSecondaryColor,
          foregroundColor: _darkOnSecondaryColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkSecondaryColor,
        foregroundColor: _darkOnSecondaryColor,
      ),
    );
  }
} 