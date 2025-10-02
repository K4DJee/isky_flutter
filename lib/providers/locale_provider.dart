import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isky_new/l10n/app_localizations.dart';

class LocaleProvider  extends ChangeNotifier{
  Locale? _locale;
  Locale? get locale => _locale;

  LocaleProvider(SharedPreferences prefs) {
    final languageCode = prefs.getString('language_code') ?? 'ru';  // Синхронно загружаем
    _locale = Locale(languageCode);  // Создаём Locale из кода языка
    // notifyListeners() не нужен здесь, так как это инициализация
  }

  Future<void> setLocale(Locale locale) async{
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners(); // Обновляет UI
  }
}