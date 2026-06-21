import 'package:flutter/material.dart';

class VaaniTheme {
  const VaaniTheme._();

  static const primary = Color(0xFF4648D4);
  static const primaryContainer = Color(0xFFE1E0FF);
  static const secondary = Color(0xFF006C49);
  static const secondaryContainer = Color(0xFF6CF8BB);
  static const surface = Color(0xFFFCF8FF);
  static const surfaceContainer = Color(0xFFF5F2FE);
  static const surfaceContainerHigh = Color(0xFFE9E6F3);
  static const onSurface = Color(0xFF1B1B23);
  static const onSurfaceVariant = Color(0xFF464554);
  static const radius = 8.0;
  static const controlRadius = 10.0;
  static const sheetRadius = 20.0;

  static LinearGradient aiGradientFor(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7073FF), Color(0xFF2ED39C)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, Color(0xFF4EDEA3)],
    );
  }

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF07006C),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF002113),
      tertiary: Color(0xFFB55D00),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFDCC5),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceContainerHigh,
      outline: Color(0xFF767586),
      outlineVariant: Color(0xFFC7C4D7),
    );
    return _themeFor(scheme);
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: Color(0xFFBFC0FF),
      onPrimary: Color(0xFF171A7A),
      primaryContainer: Color(0xFF2A2D8A),
      onPrimaryContainer: Color(0xFFE9EAFF),
      secondary: Color(0xFF88F0C4),
      onSecondary: Color(0xFF003920),
      secondaryContainer: Color(0xFF124B35),
      onSecondaryContainer: Color(0xFFB8FFD9),
      tertiary: Color(0xFFFFC58C),
      onTertiary: Color(0xFF3A2200),
      tertiaryContainer: Color(0xFF5C3600),
      onTertiaryContainer: Color(0xFFFFE8D0),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
      onError: Color(0xFF690005),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF11131A),
      onSurface: Color(0xFFF3F2FA),
      surfaceContainerHighest: Color(0xFF1E222D),
      outline: Color(0xFF8A90A4),
      outlineVariant: Color(0xFF313648),
    );
    return _themeFor(scheme);
  }

  static ThemeData _themeFor(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final cardColor = isDark ? scheme.surfaceContainerHighest : Colors.white;
    final fillColor = isDark ? scheme.surface : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: 'Plus Jakarta Sans',
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(48, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.12,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          height: 1.18,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.35,
          letterSpacing: 0,
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
