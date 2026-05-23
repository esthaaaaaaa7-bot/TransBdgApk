import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryDark = Color(0xFF0A3D62);
  static const Color primary = Color(0xFF0F4C75);
  static const Color primaryLight = Color(0xFF1B7FA6);
  static const Color accentBlue = Color(0xFF7DD3FC);

  // Semantic Colors
  static const Color green = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF059669);
  static const Color red = Color(0xFFDC2626);
  static const Color orange = Color(0xFFD97706);

  // Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderMedium = Color(0xFFE2E8F0);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A3D62),
      Color(0xFF0F6B8E),
      Color(0xFF1A8CB0),
      Color(0xFF4DADC9),
      Color(0xFFA8DCE9),
      Color(0xFFF8FAFC),
    ],
    stops: [0.0, 0.4, 0.65, 0.8, 0.9, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [greenDark, green],
  );

  // Badge colors
  static Color badgeBg(String type) {
    switch (type.toLowerCase()) {
      case 'damri': return const Color(0xFFE0F2FE);
      case 'angkot': return const Color(0xFFFEE2E2);
      case 'transmetro':
      case 'trans metro': return const Color(0xFFD1FAE5);
      default: return const Color(0xFFE0F2FE);
    }
  }

  static Color badgeText(String type) {
    switch (type.toLowerCase()) {
      case 'damri': return const Color(0xFF0369A1);
      case 'angkot': return red;
      case 'transmetro':
      case 'trans metro': return greenDark;
      default: return const Color(0xFF0369A1);
    }
  }

  static LinearGradient numberGradient(String type) {
    switch (type.toLowerCase()) {
      case 'damri': return primaryGradient;
      case 'angkot': return const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFF87171)]);
      case 'transmetro':
      case 'trans metro': return greenGradient;
      default: return primaryGradient;
    }
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderMedium, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderMedium, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
