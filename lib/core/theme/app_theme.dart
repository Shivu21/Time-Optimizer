import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6200EE); // Deep purple
  static const Color secondaryColor = Color(0xFF03DAC5); // Teal
  static const Color accentColor = Color(0xFFFF4081); // Pink accent
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light background
  static const Color backgroundDark = Color(0xFF121212); // Dark background
  static const Color errorColor = Color(0xFFCF6679); // Error red
  static const Color successColor = Color(0xFF4CAF50); // Success green

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Border Radius
  static const double smallRadius = 4.0;
  static const double mediumRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Padding
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      surfaceContainer: backgroundLight,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textPrimaryLight,
      onError: Colors.white,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: const Color(0xFF1E1E1E),
      surfaceContainer: backgroundDark,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textPrimaryDark,
      onError: Colors.black,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    );

    final bool isDark = brightness == Brightness.dark;
    final Color textColor = isDark ? textPrimaryDark : textPrimaryLight;
    final Color disabledColor = isDark ? Colors.white38 : Colors.black38;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: textColor),
        displayMedium: textTheme.displayMedium?.copyWith(color: textColor),
        displaySmall: textTheme.displaySmall?.copyWith(color: textColor),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(color: textColor),
        titleSmall: textTheme.titleSmall?.copyWith(color: textColor),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: textColor),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: textColor),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(color: textColor),
        labelSmall: textTheme.labelSmall?.copyWith(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: textColor,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.all(mediumPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          disabledForegroundColor: disabledColor,
          disabledBackgroundColor: disabledColor.withAlpha(30),
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: mediumPadding * 1.5,
            vertical: mediumPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: mediumPadding * 1.5,
            vertical: mediumPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: mediumPadding,
            vertical: smallPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
          textStyle: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.black.withAlpha(8),
        prefixIconColor: isDark ? textSecondaryDark : textSecondaryLight,
        suffixIconColor: isDark ? textSecondaryDark : textSecondaryLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: mediumPadding,
          vertical: largePadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(largeRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(largeRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(largeRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(largeRadius),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(largeRadius),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor.withAlpha(30);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark ? Colors.white54 : Colors.black54;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(smallRadius),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? Colors.white : Colors.grey.shade900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.black : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark ? textSecondaryDark : textSecondaryLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: const CircleBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(extraLargeRadius),
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
        selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? textSecondaryDark : textSecondaryLight,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white24 : Colors.black12,
        thickness: 1,
        space: 1,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
