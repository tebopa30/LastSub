import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Soft Light: 暖色系白基調・丸みのある柔らかいデザイン ──
  static final softLightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE8927C),
      primary: const Color(0xFFD4735E),
      secondary: const Color(0xFFF2B880),
      surface: const Color(0xFFFFFAF5),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF8F2),
    textTheme: GoogleFonts.mPlusRounded1cTextTheme(ThemeData.light().textTheme),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: const Color(0xFFE8927C).withOpacity(0.18),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFFF8F2),
      foregroundColor: const Color(0xFF5C3A2E),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.mPlusRounded1c(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF5C3A2E),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFD4735E),
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFD4735E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFF0E8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // ── Deep Dark: 黒基調・ミニマリスト・シックで尖ったデザイン ──
  static final deepDarkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00E5FF),
      primary: const Color(0xFF00E5FF),
      secondary: const Color(0xFFFF4081),
      surface: const Color(0xFF111111),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    textTheme: GoogleFonts.ibmPlexMonoTextTheme(ThemeData.dark().textTheme),
    cardTheme: const CardThemeData(
      color: Color(0xFF161616),
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        side: BorderSide(color: Color(0xFF2A2A2A), width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0A0A0A),
      foregroundColor: const Color(0xFFE0E0E0),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.ibmPlexMono(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE0E0E0),
        letterSpacing: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00E5FF),
      foregroundColor: Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF00E5FF),
        foregroundColor: const Color(0xFF0A0A0A),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      labelStyle: const TextStyle(color: Color(0xFF888888)),
      hintStyle: const TextStyle(color: Color(0xFF444444)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFF2A2A2A)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFF2A2A2A)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFF00E5FF), width: 1),
      ),
    ),
    dividerColor: const Color(0xFF2A2A2A),
  );
}
