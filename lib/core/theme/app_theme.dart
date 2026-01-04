import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light Theme Colors
  static const Color _lightPrimary = Color(0xFF00BF63);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightPrimaryContainer = Color(0xFFEADDFF);
  static const Color _lightOnPrimaryContainer = Color(0xFF21005D);

  static const Color _lightSecondary = Color(0xFF625B71);
  static const Color _lightOnSecondary = Color(0xFFFFFFFF);
  static const Color _lightSecondaryContainer = Color(0xFFE8DEF8);
  static const Color _lightOnSecondaryContainer = Color(0xFF1D192B);

  static const Color _lightTertiary = Color(0xFF7D5260);
  static const Color _lightOnTertiary = Color(0xFFFFFFFF);
  static const Color _lightTertiaryContainer = Color(0xFFFFD8E4);
  static const Color _lightOnTertiaryContainer = Color(0xFF31111D);

  static const Color _lightError = Color(0xFFB3261E);
  static const Color _lightOnError = Color(0xFFFFFFFF);
  static const Color _lightErrorContainer = Color(0xFFF9DEDC);
  static const Color _lightOnErrorContainer = Color(0xFF410E0B);

  static const Color _lightBackground = Color(0xFFFFFBFE);
  // static const Color _lightOnBackground = Color(0xFF1C1B1F);
  static const Color _lightSurface = Color(0xFFFFFBFE);
  static const Color _lightOnSurface = Color(0xFF1C1B1F);
  static const Color _lightSurfaceVariant = Color(0xFFE7E0EC);
  static const Color _lightOnSurfaceVariant = Color(0xFF49454F);

  static const Color _lightOutline = Color(0xFF79747E);
  static const Color _lightOutlineVariant = Color(0xFFCAC4D0);
  static const Color _lightShadow = Color(0xFF000000);
  static const Color _lightScrim = Color(0xFF000000);
  static const Color _lightInverseSurface = Color(0xFF313033);
  static const Color _lightInverseOnSurface = Color(0xFFF4EFF4);
  static const Color _lightInversePrimary = Color(0xFFD0BCFF);

  // Dark Theme Colors - Blacked Out Theme
  static const Color _darkPrimary = Color(0xFF00BF63);
  static const Color _darkOnPrimary = Color(0xFF3700B3);
  static const Color _darkPrimaryContainer = Color(0xFF3700B3);
  static const Color _darkOnPrimaryContainer = Color(0xFFE1BEE7);

  static const Color _darkSecondary = Color(0xFF03DAC6);
  static const Color _darkOnSecondary = Color(0xFF000000);
  static const Color _darkSecondaryContainer = Color(0xFF005047);
  static const Color _darkOnSecondaryContainer = Color(0xFF80CBC4);

  static const Color _darkTertiary = Color(0xFFCF6679);
  static const Color _darkOnTertiary = Color(0xFF000000);
  static const Color _darkTertiaryContainer = Color(0xFF930042);
  static const Color _darkOnTertiaryContainer = Color(0xFFF48FB1);

  static const Color _darkError = Color(0xFFCF6679);
  static const Color _darkOnError = Color(0xFF000000);
  static const Color _darkErrorContainer = Color(0xFF930042);
  static const Color _darkOnErrorContainer = Color(0xFFFFCDD2);

  static const Color _darkBackground = Color(0xFF000000);
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkOnSurface = Color(0xFFE0E0E0);
  static const Color _darkSurfaceVariant = Color(0xFF1E1E1E);
  static const Color _darkOnSurfaceVariant = Color(0xFFB0B0B0);

  static const Color _darkOutline = Color(0xFF757575);
  static const Color _darkOutlineVariant = Color(0xFF2C2C2C);
  static const Color _darkShadow = Color(0xFF000000);
  static const Color _darkScrim = Color(0xFF000000);
  static const Color _darkInverseSurface = Color(0xFFE0E0E0);
  static const Color _darkInverseOnSurface = Color(0xFF121212);
  static const Color _darkInversePrimary = Color(0xFF6200EA);

  // Light Theme
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _lightPrimary,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: _lightOnPrimary,
        primaryContainer: _lightPrimaryContainer,
        onPrimaryContainer: _lightOnPrimaryContainer,
        secondary: _lightSecondary,
        onSecondary: _lightOnSecondary,
        secondaryContainer: _lightSecondaryContainer,
        onSecondaryContainer: _lightOnSecondaryContainer,
        tertiary: _lightTertiary,
        onTertiary: _lightOnTertiary,
        tertiaryContainer: _lightTertiaryContainer,
        onTertiaryContainer: _lightOnTertiaryContainer,
        error: _lightError,
        onError: _lightOnError,
        errorContainer: _lightErrorContainer,
        onErrorContainer: _lightOnErrorContainer,
        surface: _lightSurface,
        onSurface: _lightOnSurface,
        surfaceContainerHighest: _lightSurfaceVariant,
        onSurfaceVariant: _lightOnSurfaceVariant,
        outline: _lightOutline,
        outlineVariant: _lightOutlineVariant,
        shadow: _lightShadow,
        scrim: _lightScrim,
        inverseSurface: _lightInverseSurface,
        onInverseSurface: _lightInverseOnSurface,
        inversePrimary: _lightInversePrimary,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightOnSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: _lightInverseOnSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _darkPrimary,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: _darkOnPrimary,
        primaryContainer: _darkPrimaryContainer,
        onPrimaryContainer: _darkOnPrimaryContainer,
        secondary: _darkSecondary,
        onSecondary: _darkOnSecondary,
        secondaryContainer: _darkSecondaryContainer,
        onSecondaryContainer: _darkOnSecondaryContainer,
        tertiary: _darkTertiary,
        onTertiary: _darkOnTertiary,
        tertiaryContainer: _darkTertiaryContainer,
        onTertiaryContainer: _darkOnTertiaryContainer,
        error: _darkError,
        onError: _darkOnError,
        errorContainer: _darkErrorContainer,
        onErrorContainer: _darkOnErrorContainer,
        surface: _darkSurface,
        onSurface: _darkOnSurface,
        surfaceContainerHighest: _darkSurfaceVariant,
        onSurfaceVariant: _darkOnSurfaceVariant,
        outline: _darkOutline,
        outlineVariant: _darkOutlineVariant,
        shadow: _darkShadow,
        scrim: _darkScrim,
        inverseSurface: _darkInverseSurface,
        onInverseSurface: _darkInverseOnSurface,
        inversePrimary: _darkInversePrimary,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
      ),
    );
  }
}

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(isDark: true)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeState(isDark: !state.isDark));
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState(isDark: json['isDark'] as bool);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    try {
      return {'isDark': state.isDark};
    } catch (e) {
      return null;
    }
  }
}
