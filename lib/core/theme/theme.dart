import 'package:flutter/material.dart';

/// Paleta de colores de la app.
class AppColors {
  AppColors._(); // Evita instanciar esta clase, es solo un namespace.

  // --- Marca / identidad ---
  static const Color primary = Color(0xFF16376E); // Azul oscuro (fondo)
  static const Color primaryButton = Color(0xFF2E5EAA); // Azul medio (botones)

  // --- Acciones semánticas ---
  static const Color danger = Color(0xFFFB6351); // Botón "AC"
  static const Color warning = Color(0xFFFB8D51); // Botón "C"
  static const Color success = Color(0xFF4CAF50); // Agregar / positivo
  static const Color multiply = Color(0xFF9C27B0); // Multiplicar

  // --- Superficies ---
  static const Color surface = Color(0xFFFDFDFD); // Displays principales
  static const Color surfaceMuted = Color(0xFFF5F5F5); // Display secundario
  static const Color keypadButton = Color(0xFFD9D9D9); // Teclado numérico
  static const Color cardNeutral = Color(0xFFE0E0E0); // Fondo tarjeta sin resaltar

  // --- Estados de vuelto/devolución ---
  static const Color successBackground = Color(0xFFDCEDC8);
  static const Color dangerBackground = Color(0xFFFFCDD2);

  // --- Texto ---
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
}

/// Tema global de la aplicación.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.primaryButton,
      surface: AppColors.surface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.primary,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.keypadButton,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
      ),
    );
  }
}