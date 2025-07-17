import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: Colors.green[400],
    scaffoldBackgroundColor: Color(0xFF0A0A0A), // Dark terminal background
    cardColor: Color(0xFF1A1A1A), // Dark card background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      foregroundColor: Colors.green[400],
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.green[400],
        fontFamily: 'VT323',
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.green[400],
        fontFamily: 'VT323',
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0, 
        color: Colors.green[300],
        fontFamily: 'Courier',
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0, 
        color: Colors.green[300],
        fontFamily: 'Courier',
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.green[400],
    ),
  );

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    primaryColor: Colors.green[800],
    scaffoldBackgroundColor: Color(0xFFF5F5F0), // Off-white terminal background
    cardColor: Color(0xFFE8E8E0), // Light card background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFE8E8E0),
      elevation: 0,
      foregroundColor: Colors.green[800],
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.green[800],
        fontFamily: 'VT323',
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.green[800],
        fontFamily: 'VT323',
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0, 
        color: Colors.green[700],
        fontFamily: 'Courier',
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0, 
        color: Colors.green[700],
        fontFamily: 'Courier',
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.green[800],
    ),
  );

  static ThemeData get pinkTheme => ThemeData.light().copyWith(
    primaryColor: Color(0xFFF3B2C7), // R:243 G:178 B:199
    scaffoldBackgroundColor: Color(0xFFFDF8FA), // Very light pink background
    cardColor: Color(0xFFF9F0F3), // Light pink card background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF9F0F3),
      elevation: 0,
      foregroundColor: Color(0xFFD1477A), // Darker pink for contrast
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Color(0xFFD1477A),
        fontFamily: 'VT323',
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Color(0xFFD1477A),
        fontFamily: 'VT323',
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0, 
        color: Color(0xFFB8396B),
        fontFamily: 'Courier',
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0, 
        color: Color(0xFFB8396B),
        fontFamily: 'Courier',
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFD1477A),
    ),
  );

  // Helper methods for consistent theming
  static Color getAccentColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's the pink theme
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Color(0xFFD1477A);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[400]! 
        : Colors.green[800]!;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's the pink theme
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Color(0xFFB8396B);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[300]! 
        : Colors.green[700]!;
  }

  static Color getTerminalBorder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's the pink theme
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Color(0xFFF3B2C7).withOpacity(0.6);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[400]!.withOpacity(0.6) 
        : Colors.green[800]!.withOpacity(0.4);
  }

  static Color getTerminalBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's the pink theme
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Color(0xFFF9F0F3);
    }
    
    return brightness == Brightness.dark 
        ? Color(0xFF1A1A1A) 
        : Color(0xFFE8E8E0);
  }

  static Color getCodeBlockBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's the pink theme
    if (primaryColor == Color(0xFFF3B2C7)) {
      return Color(0xFFF3B2C7).withOpacity(0.1);
    }
    
    return brightness == Brightness.dark 
        ? Colors.black26 
        : Colors.green[800]!.withOpacity(0.1);
  }
}