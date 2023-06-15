import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode); //다크모드 설정 저장

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox()
      ? ThemeMode.dark
      : ThemeMode.light; //설정에 따라 기본, 다크모드로 변환
  void SwitchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
