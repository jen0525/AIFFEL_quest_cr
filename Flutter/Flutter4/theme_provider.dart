import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    print('notifyListeners() called');
    notifyListeners();
    print('_isDarkMode: $_isDarkMode');
  }
}