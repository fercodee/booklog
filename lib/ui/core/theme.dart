import 'package:flutter/material.dart';
import 'colors.dart';

/// Tema global do aplicativo Book Log
abstract final class AppTheme {
  /// Tema light do aplicativo
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Cores primárias
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        centerTitle: true,
        elevation: 2,
        iconTheme: IconThemeData(
          color: AppColors.textOnPrimary,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Scheme de cores
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.bgPrimary,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
      ),
      
      // Texto
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.gray500),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.gray900,
        contentTextStyle: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 14,
        ),
      ),
    );
  }
}
