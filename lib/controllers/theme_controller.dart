import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
} 