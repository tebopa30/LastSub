import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Natural Soft: 白とベージュ・淡いグリーン・大きな角丸・優しい印象 ──
  static final naturalSoftTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7BAE8B),   // 淡いグリーン
      primary: const Color(0xFF5A9470),
      secondary: const Color(0xFFA8C5A0),
      surface: const Color(0xFFFAF7F2),     // 温かみのある白
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F0E8), // ベージュがかった背景
    textTheme: GoogleFonts.mPlusRounded1cTextTheme(ThemeData.light().textTheme),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: const Color(0xFF7BAE8B).withOpacity(0.15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF5F0E8),
      foregroundColor: const Color(0xFF2D4A38),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.mPlusRounded1c(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2D4A38),
        letterSpacing: 0.5,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF5A9470),
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF5A9470),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEEF5EC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    dividerColor: const Color(0xFFDDD8D0),
  );

  // ── Classic Sleek: 黒とダークグレー・細いフォント・極限までシンプル ──
  static final classicSleekTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFCCCCCC),
      primary: const Color(0xFFE0E0E0),
      secondary: const Color(0xFF888888),
      surface: const Color(0xFF1A1A1A),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: const Color(0xFFD0D0D0),
      displayColor: const Color(0xFFFFFFFF),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF181818),
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: Color(0xFF2C2C2C), width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0D0D0D),
      foregroundColor: const Color(0xFFD0D0D0),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w300,   // 細いフォントでミニマリスト感
        color: const Color(0xFFFFFFFF),
        letterSpacing: 3,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      foregroundColor: Color(0xFFE0E0E0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2C2C2C),
        foregroundColor: const Color(0xFFE0E0E0),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      labelStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
      hintStyle: const TextStyle(color: Color(0xFF444444)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFF2C2C2C)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFF2C2C2C)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    ),
    dividerColor: const Color(0xFF2C2C2C),
  );
}
