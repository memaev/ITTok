import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color primaryAccent = Color(0xFF6C63FF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFF2A2A2A);
  static const Color liked = Color(0xFFFF4081);
  static const Color saved = Color(0xFF6C63FF);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primaryAccent,
        onPrimary: textPrimary,
        onSurface: textPrimary,
        outline: divider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryAccent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
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
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: GoogleFonts.inter(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
