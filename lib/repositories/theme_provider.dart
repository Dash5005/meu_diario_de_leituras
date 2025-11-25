import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _settingsBox = 'app_settings';
  static const String _themeKey = 'isDark';

  ThemeMode _mode;
  ThemeProvider({ThemeMode initialMode = ThemeMode.light})
    : _mode = initialMode {
    _loadFromStorage();
  }

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> _loadFromStorage() async {
    try {
      if (!Hive.isBoxOpen(_settingsBox)) {
        await Hive.openBox(_settingsBox);
      }
      final box = Hive.box(_settingsBox);
      final saved = box.get(_themeKey);
      if (saved is bool) {
        _mode = saved ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    } catch (e, st) {
      debugPrint('Erro ao carregar tema: $e\n$st');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      if (!Hive.isBoxOpen(_settingsBox)) {
        await Hive.openBox(_settingsBox);
      }
      final box = Hive.box(_settingsBox);
      await box.put(_themeKey, isDark);
    } catch (e, st) {
      debugPrint('Erro ao salvar tema: $e\n$st');
    }
  }

  void toggleTheme() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveToStorage();
  }

  void setDark() {
    _mode = ThemeMode.dark;
    notifyListeners();
    _saveToStorage();
  }

  void setLight() {
    _mode = ThemeMode.light;
    notifyListeners();
    _saveToStorage();
  }
}
