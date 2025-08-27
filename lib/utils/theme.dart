import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color successColor = Color(0xFF4CAF50);
  
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: surfaceColor,
      foregroundColor: Colors.black87,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: surfaceColor,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200],
      selectedColor: primaryColor.withOpacity(0.2),
      labelStyle: const TextStyle(fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: darkSurfaceColor,
      foregroundColor: Colors.white,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: darkSurfaceColor,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: darkSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800],
      selectedColor: primaryColor.withOpacity(0.3),
      labelStyle: const TextStyle(fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[700],
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.white70,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    ),
  );

  // Priority Colors
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 0: // Low
        return Colors.grey;
      case 1: // Medium
        return Colors.blue;
      case 2: // High
        return Colors.orange;
      case 3: // Urgent
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Status Colors
  static Color getStatusColor(int status) {
    switch (status) {
      case 0: // Pending
        return Colors.grey;
      case 1: // InProgress
        return Colors.blue;
      case 2: // Completed
        return Colors.green;
      case 3: // Cancelled
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
