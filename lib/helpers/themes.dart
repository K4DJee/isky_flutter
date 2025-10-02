// providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late bool _isDark;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    _isDark = _prefs.getBool('isDarkMode') ?? false; // По умолчанию светлая тема
  }

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    _prefs.setBool('isDarkMode', _isDark);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get currentTheme => _isDark ? _darkTheme : _lightTheme;

  // Светлая тема
  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 183, 58)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        cardTheme: CardThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
          surfaceTintColor: Colors.white.withOpacity(0.05),
          shadowColor: Colors.white,
          elevation: 4,
        ),
        cardColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      );

  // Темная тема
  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 77, 183, 58),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          shadowColor: Colors.black,
          elevation: 4,
        ),
        cardColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
}