import 'package:flutter/material.dart';

import '../dynamik_theme.dart';

enum SimpleThemeType {
  light(ThemeState(themeMode: ThemeMode.light)),
  dark(ThemeState(themeMode: ThemeMode.dark)),
  dynamik(ThemeState(
    themeMode: ThemeMode.system,
    colorMode: ColorMode.dynamik,
  ));

  const SimpleThemeType(this.themeData);
  final ThemeState themeData;
}
