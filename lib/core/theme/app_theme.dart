import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Extra brand tokens that don't map onto [ColorScheme] — access via
/// `Theme.of(context).extension<AppSemanticColors>()!`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color inkDim;
  final Color border;
  final Color surface2;
  final Color primarySoft;
  final Color accent;
  final Color accentSoft;

  const AppSemanticColors({
    required this.inkDim,
    required this.border,
    required this.surface2,
    required this.primarySoft,
    required this.accent,
    required this.accentSoft,
  });

  @override
  AppSemanticColors copyWith({
    Color? inkDim,
    Color? border,
    Color? surface2,
    Color? primarySoft,
    Color? accent,
    Color? accentSoft,
  }) {
    return AppSemanticColors(
      inkDim: inkDim ?? this.inkDim,
      border: border ?? this.border,
      surface2: surface2 ?? this.surface2,
      primarySoft: primarySoft ?? this.primarySoft,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      inkDim: Color.lerp(inkDim, other.inkDim, t)!,
      border: Color.lerp(border, other.border, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ink = isDark ? AppColors.inkDark : AppColors.inkLight;
    final inkDim = isDark ? AppColors.inkDimDark : AppColors.inkDimLight;
    final moss = isDark ? AppColors.mossDark : AppColors.mossLight;
    final mossSoft = isDark ? AppColors.mossSoftDark : AppColors.mossSoftLight;
    final clay = isDark ? AppColors.clayDark : AppColors.clayLight;
    final claySoft = isDark ? AppColors.claySoftDark : AppColors.claySoftLight;
    final paper = isDark ? AppColors.paperDark : AppColors.paperLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surface2 = isDark ? AppColors.surface2Dark : AppColors.surface2Light;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: moss,
      onPrimary: isDark ? AppColors.paperDark : Colors.white,
      secondary: clay,
      onSecondary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: surface,
      onSurface: ink,
      outline: border,
    );

    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paper,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: ink),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: moss),
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        labelStyle: TextStyle(
          color: inkDim,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: inkDim),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: moss, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: moss,
        unselectedItemColor: inkDim,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      extensions: [
        AppSemanticColors(
          inkDim: inkDim,
          border: border,
          surface2: surface2,
          primarySoft: mossSoft,
          accent: clay,
          accentSoft: claySoft,
        ),
      ],
    );
  }
}
