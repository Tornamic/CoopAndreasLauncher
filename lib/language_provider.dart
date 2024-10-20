import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes/storage_data.dart';
import 'constants.dart';

class LanguageProvider extends ChangeNotifier {

  late final SharedPreferences _prefs;
  late Locale _locale = const Locale(defaultLanguageCode);
  Locale get locale => _locale;

  LanguageProvider(this._prefs) {
    _locale = Locale(_prefs.getString('languageCode') ?? defaultLanguageCode);
  }

  void setLocale(Locale locale) {
    if (_locale == locale) {
      return;
    }

    _locale = locale;
    StorageData.setStorageStringFieldData('languageCode', _locale.languageCode);
    notifyListeners();
  }
}