import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- CORES ---
  static const Color primaryGreen = Color(0xFF1EEA7E); // Verde Neon Suave
  static const Color primaryColor = primaryGreen;
  static const Color emeraldGreen = Color(0xFF00C853); // Verde Esmeralda
  static const Color electricGreen = Color(0xFF76FF03); // Verde Elétrico
  static const Color petroleumBlue = Color(0xFF0D47A1); // Azul Petróleo
  static const Color lemonYellow = Color(0xFFFDD835); // Amarelo-Limão
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color graphiteGray = Color(0xFF212121);
  static const Color lightGray = Color(0xFF424242);
  static const Color background = Color(0xFF121212);

  // --- BORDAS ---
  static final BorderRadius borderRadius = BorderRadius.circular(22);

  // --- SOMBRAS ---
  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> subtle3DShadow = [
    BoxShadow(
      color: primaryGreen.withOpacity(0.15),
      blurRadius: 25,
      spreadRadius: -5,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  // --- GRADIENTES ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [emeraldGreen, petroleumBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- TEMA GERAL ---
  static ThemeData get themeData {
    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: background,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryGreen,
        secondary: petroleumBlue,
        surface: lightGray,
        onSurface: pureWhite,
        error: lemonYellow,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        headlineLarge: GoogleFonts.poppins(
            fontSize: 32, fontWeight: FontWeight.w700, color: pureWhite),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.w600, color: pureWhite),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 16, color: pureWhite.withOpacity(0.8)),
        bodyMedium:
            GoogleFonts.poppins(fontSize: 14, color: pureWhite.withOpacity(0.7)),
        labelLarge: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: graphiteGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: graphiteGray,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 8,
          shadowColor: primaryGreen.withOpacity(0.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightGray.withOpacity(0.5),
        selectedColor: primaryGreen.withOpacity(0.8),
        labelStyle: GoogleFonts.poppins(color: pureWhite, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.transparent)),
      ),
      iconTheme: const IconThemeData(color: pureWhite, size: 26),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: pureWhite),
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.w600, color: pureWhite),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: graphiteGray.withOpacity(0.9),
        selectedItemColor: primaryGreen,
        unselectedItemColor: pureWhite.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
