import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefKey = 'theme_mode';

final themeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey);
    if (stored == 'light') {
      _mode = ThemeMode.light;
    } else if (stored == 'dark') {
      _mode = ThemeMode.dark;
    }

    // Flutter web hash URLs put ?query= in the fragment (/#/?theme=light),
    // so Uri.base.queryParameters is empty — parse from the fragment too.
    final themeQuery = _queryParam('theme');
    if (themeQuery == 'light') {
      _mode = ThemeMode.light;
    } else if (themeQuery == 'dark') {
      _mode = ThemeMode.dark;
    }
    notifyListeners();
  }

  String? _queryParam(String key) {
    final direct = Uri.base.queryParameters[key];
    if (direct != null) return direct;
    final fragment = Uri.base.fragment;
    if (fragment.isEmpty) return null;
    final q = fragment.indexOf('?');
    if (q < 0) return null;
    return Uri.parse('http://local/?${fragment.substring(q + 1)}')
        .queryParameters[key];
  }

  Future<void> toggle() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      _mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
}
