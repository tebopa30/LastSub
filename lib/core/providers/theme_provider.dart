import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// アプリで選択できる2つのテーマ
enum AppThemeType {
  softLight,  // 暖色系白基調・丸みのある柔らかいデザイン
  deepDark,   // 黒基調・ミニマリスト・シックで尖ったデザイン
}

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _key = 'app_theme_type';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light; // 初期値は Soft Light
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == AppThemeType.deepDark.name) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> setTheme(AppThemeType type) async {
    state = type == AppThemeType.deepDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, type.name);
  }

  AppThemeType get currentType =>
      state == ThemeMode.dark ? AppThemeType.deepDark : AppThemeType.softLight;
}
