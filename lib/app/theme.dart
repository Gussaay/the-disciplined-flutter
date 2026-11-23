import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for The Disciplined — the same sheet as the React app
/// (tailwind.config.cjs + index.css), carried over so both editions look
/// like one product. Deep pine green is the brand; gold is for what was
/// earned; success / warning / danger each have exactly one colour.
abstract final class Brand {
  static const Color pine50 = Color(0xFFEEF6F4);
  static const Color pine100 = Color(0xFFD5E9E5);
  static const Color pine200 = Color(0xFFA9D2CB);
  static const Color pine300 = Color(0xFF78B5AC);
  static const Color pine400 = Color(0xFF4A958B);
  static const Color pine500 = Color(0xFF2B786F);
  static const Color pine600 = Color(0xFF1D6059);
  static const Color pine700 = Color(0xFF164D48);
  static const Color pine800 = Color(0xFF0F3D3E);
  static const Color pine900 = Color(0xFF0A2B2C);

  static const Color gold100 = Color(0xFFFBF0D0);
  static const Color gold300 = Color(0xFFEBCB73);
  static const Color gold400 = Color(0xFFE0B84A);
  static const Color gold500 = Color(0xFFC99A22);
  static const Color gold600 = Color(0xFFA67C12);

  static const Color paper = Color(0xFFF6F3EC);
  static const Color ink = Color(0xFF0C1716);
  static const Color night = Color(0xFF0B1413);
  static const Color nightCard = Color(0xFF12201F);

  static const Color success = Color(0xFF2F7D4F);
  static const Color warning = Color(0xFFB97F10);
  static const Color danger = Color(0xFFBC3B30);

  /// The hero gradient (design-refresh phase 1): deep pine, with a soft
  /// gold bloom painted over the top corner by the hero widget itself.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pine900, pine800, pine700],
    stops: [0, 0.48, 1],
  );
}

/// Per-goal accents — identical values to GOALS / MODULES in the React
/// app's src/config.js, so a glance says which goal a screen belongs to.
abstract final class GoalColors {
  static const Color gym = Color(0xFFD9622B);
  static const Color food = Color(0xFF5E8C2A);
  static const Color prayer = Color(0xFF1D6059);
  static const Color social = Color(0xFFB8436B);
  static const Color english = Color(0xFF4B5FC4);
  static const Color weight = Color(0xFF2F7FBF);
  static const Color tasks = Color(0xFF7A5BC7);
  static const Color watch = Color(0xFF0E9384);
}

ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Brand.pine800,
      primary: Brand.pine800,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Brand.paper,
    fontFamily: GoogleFonts.tajawal().fontFamily,
  );
  return base.copyWith(
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Brand.pine500,
      brightness: Brightness.dark,
      primary: Brand.pine400,
      surface: Brand.nightCard,
    ),
    scaffoldBackgroundColor: Brand.night,
    fontFamily: GoogleFonts.tajawal().fontFamily,
  );
  return base.copyWith(
    cardTheme: CardThemeData(
      color: Brand.nightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
  );
}
