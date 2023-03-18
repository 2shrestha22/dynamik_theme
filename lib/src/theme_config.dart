import 'package:dynamik_theme/src/theme_storage.dart';
import 'package:dynamik_theme/src/theme_state.dart';
import 'package:flutter/material.dart';

/// Extend this class to add further customization..
class ThemeConfig {
  ThemeConfig({
    required this.lightScheme,
    required this.darkScheme,
    required this.defaultThemeState,
    this.useMaterial3,
    this.textTheme,
    this.builder,
  });

  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final ThemeState defaultThemeState;

  final bool? useMaterial3;
  final TextTheme? textTheme;

  /// Adds furter customization on ThemeData.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// builder: (themeData) {
  ///   return themeData.copyWith(
  ///     appBarTheme: const AppBarTheme(centerTitle: true),
  ///   );
  /// }
  /// ```
  final ThemeData? Function(ThemeData themeData)? builder;

  /// Override [fromScheme] to add further customization like adding Fonts.
  ThemeData fromScheme(ColorScheme scheme) {
    final themeData = ThemeData.from(
      colorScheme: scheme,
      useMaterial3: useMaterial3,
      textTheme: textTheme,
    );
    if (builder != null) {
      return builder!.call(themeData) ?? themeData;
    }
    return themeData;
  }

  ThemeData get lightTheme => fromScheme(lightScheme);
  ThemeData get darkTheme => fromScheme(darkScheme);

  static ThemeStorage? _storage;

  /// Setter for instance of [ThemeStorage] which will be used to
  /// persist [ThemeType].
  static set storage(ThemeStorage? storage) => _storage = storage;

  /// Instance of [ThemeStorage] which will be used to
  /// persist [ThemeType].
  static ThemeStorage get storage {
    if (_storage == null) return InMemoryThemeStorage();
    return _storage!;
  }
}
