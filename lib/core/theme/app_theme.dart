import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Natural Soft: 温かみ・大きな角丸・柔らかいグリーン ────────────────
  static final naturalSoftTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7BAE8B),
      primary: const Color(0xFF5A9470),
      secondary: const Color(0xFFA8C5A0),
      surface: const Color(0xFFFAF7F2),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F0E8),
    textTheme: GoogleFonts.mPlusRounded1cTextTheme(ThemeData.light().textTheme),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: const Color(0xFF7BAE8B).withValues(alpha: 0.15),
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

  // ── Classic Sleek: スタイリッシュ・ミニマリスト・クールなアクセント ────
  static final classicSleekTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00E5FF),        // エレクトリックシアン
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF003A42),
      onPrimaryContainer: Color(0xFF00E5FF),
      secondary: Color(0xFF666666),
      onSecondary: Color(0xFFFFFFFF),
      surface: Color(0xFF111111),
      onSurface: Color(0xFFEEEEEE),
      surfaceContainerHighest: Color(0xFF1E1E1E),
      outline: Color(0xFF2E2E2E),
      outlineVariant: Color(0xFF222222),
      error: Color(0xFFFF4444),
      onError: Color(0xFF000000),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
          color: Colors.white, fontWeight: FontWeight.w200, letterSpacing: -1),
      displayMedium: GoogleFonts.inter(
          color: Colors.white, fontWeight: FontWeight.w200, letterSpacing: -0.5),
      titleLarge: GoogleFonts.inter(
          color: const Color(0xFFEEEEEE), fontWeight: FontWeight.w400, letterSpacing: 0.5),
      titleMedium: GoogleFonts.inter(
          color: const Color(0xFFEEEEEE), fontWeight: FontWeight.w500, letterSpacing: 0.3),
      titleSmall: GoogleFonts.inter(
          color: const Color(0xFF999999), fontWeight: FontWeight.w400, letterSpacing: 1.0),
      bodyLarge: GoogleFonts.inter(
          color: const Color(0xFFCCCCCC), fontWeight: FontWeight.w300),
      bodyMedium: GoogleFonts.inter(
          color: const Color(0xFFAAAAAA), fontWeight: FontWeight.w300),
      labelLarge: GoogleFonts.inter(
          color: const Color(0xFFEEEEEE), fontWeight: FontWeight.w500, letterSpacing: 1.2),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF141414),
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        side: BorderSide(color: Color(0xFF252525), width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0A0A0A),
      foregroundColor: const Color(0xFFEEEEEE),
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        color: const Color(0xFFFFFFFF),
        letterSpacing: 4,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00E5FF),
      foregroundColor: Color(0xFF000000),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: const Color(0xFF00E5FF),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
          fontSize: 13,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          side: BorderSide(color: Color(0xFF2E2E2E)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF888888),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, letterSpacing: 0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF161616),
      labelStyle: GoogleFonts.inter(color: const Color(0xFF666666), fontSize: 12),
      hintStyle: GoogleFonts.inter(color: const Color(0xFF333333), fontSize: 12),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        borderSide: BorderSide(color: Color(0xFF2E2E2E)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        borderSide: BorderSide(color: Color(0xFF252525)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        borderSide: BorderSide(color: Color(0xFF00E5FF), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    dividerColor: const Color(0xFF1E1E1E),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E1E1E),
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A1A1A),
      selectedColor: const Color(0xFF003A42),
      labelStyle: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFFCCCCCC)),
      side: const BorderSide(color: Color(0xFF2E2E2E)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        ),
        side: WidgetStateProperty.all(
          const BorderSide(color: Color(0xFF2E2E2E)),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF00E5FF);
        return const Color(0xFF1A1A1A);
      }),
      checkColor: WidgetStateProperty.all(const Color(0xFF000000)),
      side: const BorderSide(color: Color(0xFF2E2E2E), width: 1.5),
    ),
  );
}
