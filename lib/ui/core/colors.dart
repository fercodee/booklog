import 'package:flutter/material.dart';

/// Paleta de cores do aplicativo Book Log
abstract final class AppColors {
  // Cores principais
  static const Color primary = Color(0xFF000000); // Preto
  static const Color secondary = Color(0xFFFFFFFF); // Branco
  static const Color accent = Color(0xFF6200EE); // Roxo (acento)

  // Escala de cinzas
  static const Color gray100 = Color(0xFFF5F5F5); // Cinza muito claro
  static const Color gray200 = Color(0xFFEEEEEE); // Cinza claro
  static const Color gray300 = Color(0xFFE0E0E0); // Cinza
  static const Color gray500 = Color(0xFF9E9E9E); // Cinza médio
  static const Color gray700 = Color(0xFF616161); // Cinza escuro
  static const Color gray900 = Color(0xFF212121); // Cinza muito escuro

  // Cores de estado
  static const Color success = Color(0xFF4CAF50); // Verde
  static const Color error = Color(0xFFF44336); // Vermelho
  static const Color warning = Color(0xFFFFC107); // Âmbar
  static const Color info = Color(0xFF2196F3); // Azul

  // Cores de texto
  static const Color textPrimary = Color(0xFF212121); // Preto (texto principal)
  static const Color textSecondary = Color(0xFF757575); // Cinza (texto secundário)
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Branco (texto sobre preto)

  // Cores de fundo
  static const Color bgPrimary = Color(0xFFFFFFFF); // Branco
  static const Color bgSecondary = Color(0xFFFAFAFA); // Branco off
  static const Color bgDark = Color(0xFF000000); // Preto

  // Cores de borda
  static const Color border = Color(0xFFE0E0E0); // Cinza claro
  static const Color borderDark = Color(0xFF616161); // Cinza escuro
}
