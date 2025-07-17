import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Color(0xFF0A1A12),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0A1A12),
      elevation: 0,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.greenAccent,
        fontFamily: 'VT323',
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: Colors.greenAccent,
        fontFamily: 'VT323',
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0, 
        color: Colors.greenAccent,
        fontFamily: 'Courier',
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0, 
        color: Colors.greenAccent,
        fontFamily: 'Courier',
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.greenAccent,
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

  // Helper methods for consistent theming
  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.greenAccent 
        : Colors.green[800]!;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.greenAccent.withOpacity(0.7) 
        : Colors.green[600]!;
  }

  static Color getTerminalBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.greenAccent.withOpacity(0.5) 
        : Colors.green[400]!.withOpacity(0.6);
  }

  static Color getTerminalBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.black.withOpacity(0.4) 
        : Colors.green[50]!.withOpacity(0.8);
  }

  static Color getCodeBlockBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Color(0xFF0D1B0F) // Darker green-tinted background for dark theme
        : Color(0xFFF0F8F0); // Light green-tinted background for light theme
  }
}