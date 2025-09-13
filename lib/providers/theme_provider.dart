import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All neumorphism colors from Tailwind config
class NeuColors {
  // Light Mode
  static const Color neuBase = Color(0xffe6ecf8);
  static const Color neuText = Color(0xFF4A5568);

  // Dark Mode
  static const Color neuBaseDark = Color(0xFF323232);
  static const Color neuTextDark = Color(0xFFE0E0E0);
}

/// Shadows for neumorphism (both modes)
class NeuShadows {
  // Light Mode
  static const List<BoxShadow> neu = [
    BoxShadow(color: Color(0xFFC5C9D6), offset: Offset(3, 3), blurRadius: 6),
    BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 6),
  ];

  static const List<BoxShadow> neuInset = [
    BoxShadow(color: Color(0xFFC5C9D6), offset: Offset(-6, -6), blurRadius: 6, spreadRadius: -0.1),
    BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(6, 6), blurRadius: 6, spreadRadius: -0.1),
  ];

  // Dark Mode
  static const List<BoxShadow> neuDark = [
    BoxShadow(color: Color(0xFF2A2A2A), offset: Offset(3, 3), blurRadius: 3),
    BoxShadow(color: Color(0xFF2A2A2A), offset: Offset(-3, -3), blurRadius: 3),
  ];

  static const List<BoxShadow> neuInsetDark = [
    BoxShadow(color: Color(0xFF2A2A2A), offset: Offset(6, 6), blurRadius: 5, spreadRadius: -0.1),
  ];
}

/// Provides ThemeData (light + dark) for Flutter
class NeuTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: NeuColors.neuBase,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: NeuColors.neuText),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NeuColors.neuBase,
      foregroundColor: NeuColors.neuText,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: NeuColors.neuBase,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NeuColors.neuBaseDark,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: NeuColors.neuTextDark),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NeuColors.neuBaseDark,
      foregroundColor: NeuColors.neuTextDark,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: NeuColors.neuBaseDark,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );
}

/// ThemeProvider with persistence (SharedPreferences)
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = "theme_mode";

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);

    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    }
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }
}
