import 'package:flutter/material.dart';

import '../dynamik_theme.dart';

/// {@template simple_theme_type}
/// Collection of [ThemeState] for normal use. It has light mode, dark mode and
/// dynamik mode with [ThemeMode.system].
/// {@endtemplate}
enum SimpleThemeType {
  /// [ColorMode.dynamik] with [ThemeMode.system].
  dynamik(ThemeState(
    themeMode: ThemeMode.system,
    colorMode: ColorMode.dynamik,
  )),

  /// [ThemeMode.light]
  light(ThemeState(themeMode: ThemeMode.light)),

  /// [ThemeMode.dark]
  dark(ThemeState(themeMode: ThemeMode.dark));

  /// {@macro simple_theme_type}
  const SimpleThemeType(this.themeState);

  /// {@macro theme_state}
  final ThemeState themeState;
}
