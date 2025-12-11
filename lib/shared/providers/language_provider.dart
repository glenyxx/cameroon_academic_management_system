import 'package:flutter/material.dart';
import '../../data/local/hive_setup.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final settingsBox = HiveSetup.getSettingsBox();
    final savedLanguage = settingsBox.get('language', defaultValue: 'en') as String;
    _currentLocale = Locale(savedLanguage);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != _currentLocale.languageCode) {
      _currentLocale = Locale(languageCode);

      final settingsBox = HiveSetup.getSettingsBox();
      await settingsBox.put('language', languageCode);

      notifyListeners();
    }
  }

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isFrench => _currentLocale.languageCode == 'fr';

  String translate(String enText, String frText) {
    return isEnglish ? enText : frText;
  }
}