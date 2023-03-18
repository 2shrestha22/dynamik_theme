import 'dart:convert';

import 'package:flutter/material.dart';

/// Describes which color mode will be used with [DynamikThemeBuilder].
enum ColorMode {
  /// Use sytem color. In android uses Monet.
  dynamik,

  /// Manually provide seed color.
  custom,
}

class ThemeState {
  final ThemeMode themeMode;

  /// If [colorMode] is null then [seed] will be ignored.
  ///
  /// When null [colorMode] default color scheme is used provide in
  /// [ThemeConfig].
  final ColorMode? colorMode;

  /// If [colorMode] is null then [seed] will be ignored.
  final Color? seed;

  /// State of theme.
  const ThemeState({
    required this.themeMode,
    this.colorMode,
    this.seed,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    ColorMode? colorMode,
    Color? seed,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorMode: colorMode ?? this.colorMode,
      seed: seed ?? this.seed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
      'colorMode': colorMode?.name,
      'seed': seed?.value,
    };
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(
      themeMode: ThemeMode.values.byName(map['themeMode']),
      colorMode: map['colorMode'] != null
          ? ColorMode.values.byName(map['colorMode'])
          : null,
      seed: map['seed'] != null ? Color(map['seed']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeState.fromJson(String source) =>
      ThemeState.fromMap(json.decode(source));

  @override
  String toString() =>
      'ThemeData(themeMode: $themeMode, colorMode: $colorMode, seed: $seed)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeState &&
        other.themeMode == themeMode &&
        other.colorMode == colorMode &&
        other.seed == seed;
  }

  @override
  int get hashCode => themeMode.hashCode ^ colorMode.hashCode ^ seed.hashCode;
}

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
