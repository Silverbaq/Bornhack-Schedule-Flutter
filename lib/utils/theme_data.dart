import 'package:flutter/material.dart';

class AppThemes {
  // Year-based color mapping
  static const Map<int, Color> yearColors = {
    2025: Color(0xFFFFAFC7), // Pink
    2026: Color(0xFFFFFFFF), // White
    2027: Color(0xFF004DFF), // Blue
    2028: Color(0xFF750787), // Purple
    2029: Color(0xFF008026), // Green
  };

  static Color getCurrentYearColor() {
    final currentYear = DateTime.now().year;
    return yearColors[currentYear] ?? Color(0xFFFFAFC7); // Default to 2025 color
  }

  static String getCurrentYearName() {
    final currentYear = DateTime.now().year;
    return currentYear.toString();
  }

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

  static ThemeData get yearTheme {
    final yearColor = getCurrentYearColor();
    final accentColor = _getYearAccentColor(yearColor);
    final backgroundColor = _getYearBackgroundColor(yearColor);
    final cardColor = _getYearCardColor(yearColor);
    
    return ThemeData.light().copyWith(
      primaryColor: yearColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        elevation: 0,
        foregroundColor: accentColor,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: accentColor,
          fontFamily: 'VT323',
        ),
        headlineMedium: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: accentColor,
          fontFamily: 'VT323',
        ),
        bodyLarge: TextStyle(
          fontSize: 14.0, 
          color: accentColor.withOpacity(0.8),
          fontFamily: 'Courier',
        ),
        bodyMedium: TextStyle(
          fontSize: 12.0, 
          color: accentColor.withOpacity(0.8),
          fontFamily: 'Courier',
        ),
      ),
      iconTheme: IconThemeData(
        color: accentColor,
      ),
    );
  }

  static Color _getYearAccentColor(Color yearColor) {
    // Generate appropriate accent colors based on the year color
    if (yearColor == Color(0xFFFFFFFF)) { // White - use dark accent
      return Color(0xFF333333);
    } else if (yearColor == Color(0xFF004DFF)) { // Blue - use lighter blue
      return Color(0xFF0066FF);
    } else if (yearColor == Color(0xFF750787)) { // Purple - use lighter purple
      return Color(0xFF9A0FA5);
    } else if (yearColor == Color(0xFF008026)) { // Green - use lighter green
      return Color(0xFF00A032);
    } else { // Pink or default - use darker pink
      return Color(0xFFD1477A);
    }
  }

  static Color _getYearBackgroundColor(Color yearColor) {
    // Generate appropriate background colors
    if (yearColor == Color(0xFFFFFFFF)) { // White
      return Color(0xFFFAFAFA);
    } else if (yearColor == Color(0xFF004DFF)) { // Blue
      return Color(0xFFF0F4FF);
    } else if (yearColor == Color(0xFF750787)) { // Purple
      return Color(0xFFF8F0F9);
    } else if (yearColor == Color(0xFF008026)) { // Green
      return Color(0xFFF0F8F2);
    } else { // Pink or default
      return Color(0xFFFDF8FA);
    }
  }

  static Color _getYearCardColor(Color yearColor) {
    // Generate appropriate card colors
    if (yearColor == Color(0xFFFFFFFF)) { // White
      return Color(0xFFF5F5F5);
    } else if (yearColor == Color(0xFF004DFF)) { // Blue
      return Color(0xFFE8F0FF);
    } else if (yearColor == Color(0xFF750787)) { // Purple
      return Color(0xFFF3E8F5);
    } else if (yearColor == Color(0xFF008026)) { // Green
      return Color(0xFFE8F5EA);
    } else { // Pink or default
      return Color(0xFFF9F0F3);
    }
  }

  // Helper methods for consistent theming
  static Color getAccentColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's a year theme
    if (yearColors.containsValue(primaryColor)) {
      return _getYearAccentColor(primaryColor);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[400]! 
        : Colors.green[800]!;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's a year theme
    if (yearColors.containsValue(primaryColor)) {
      return _getYearAccentColor(primaryColor).withOpacity(0.8);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[300]! 
        : Colors.green[700]!;
  }

  static Color getTerminalBorder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's a year theme
    if (yearColors.containsValue(primaryColor)) {
      return _getYearAccentColor(primaryColor).withOpacity(0.6);
    }
    
    return brightness == Brightness.dark 
        ? Colors.green[400]!.withOpacity(0.6) 
        : Colors.green[800]!.withOpacity(0.4);
  }

  static Color getTerminalBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's a year theme
    if (yearColors.containsValue(primaryColor)) {
      return _getYearCardColor(primaryColor);
    }
    
    return brightness == Brightness.dark 
        ? Color(0xFF1A1A1A) 
        : Color(0xFFE8E8E0);
  }

  static Color getCodeBlockBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Check if it's a year theme
    if (yearColors.containsValue(primaryColor)) {
      return _getYearAccentColor(primaryColor).withOpacity(0.1);
    }
    
    return brightness == Brightness.dark 
        ? Colors.black26 
        : Colors.green[800]!.withOpacity(0.1);
  }

  static bool isYearTheme(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return yearColors.containsValue(primaryColor);
  }
}