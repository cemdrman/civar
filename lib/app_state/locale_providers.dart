import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePrefsKey = 'civar_locale_code';
const supportedLocaleCodes = ['tr', 'en', 'ar', 'pt', 'fr'];

/// Persists the user's chosen app language across restarts. Defaults to the
/// device locale when it's one of the 5 supported languages, otherwise falls
/// back to Turkish (the app's original language).
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadPersisted();
    return _deviceOrDefaultLocale();
  }

  Locale _deviceOrDefaultLocale() {
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    return supportedLocaleCodes.contains(deviceCode) ? Locale(deviceCode) : const Locale('tr');
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_localePrefsKey);
    if (saved != null && supportedLocaleCodes.contains(saved)) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePrefsKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
