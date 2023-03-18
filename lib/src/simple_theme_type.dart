import 'package:flutter/material.dart';

import '../dynamik_theme.dart';

enum SimpleThemeType {
  dynamik(ThemeState(
    themeMode: ThemeMode.system,
    colorMode: ColorMode.dynamik,
  )),
  light(ThemeState(themeMode: ThemeMode.light)),
  dark(ThemeState(themeMode: ThemeMode.dark));

  const SimpleThemeType(this.themeData);
  final ThemeState themeData;
}
