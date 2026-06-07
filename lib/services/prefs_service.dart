import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _themeKey = 'theme_mode';

  Future<void> setThemeMode(String mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  Future<String> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system';
  }
}
