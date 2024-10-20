import 'package:flutter/material.dart';
import '../classes/storage_data.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool getStorageDarkModeStateFailReturn(bool failReturn) {
    return StorageData.getStorageBoolFieldData('isDarkMode') ?? failReturn;
  }

  ThemeProvider(Brightness brightness) {
    initTheme(brightness);
  }

  void initTheme(Brightness brightness) {
    dynamic tempIsDarkMode = StorageData.getStorageBoolFieldData('isDarkMode');

    _isDarkMode = tempIsDarkMode ?? brightness == Brightness.dark;

    if(tempIsDarkMode == null) {
      saveTheme();
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    saveTheme();
    notifyListeners();
  }

  void saveTheme() {
    StorageData.setStorageBoolFieldData('isDarkMode', _isDarkMode);
  }
}