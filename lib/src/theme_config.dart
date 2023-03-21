import 'package:dynamik_theme/src/theme_storage.dart';
import 'package:dynamik_theme/src/theme_state.dart';
import 'package:flutter/material.dart';

/// {@template theme_config}
/// Configuration for [DynamikTheme].
/// {@endtemplate}
class ThemeConfig {
  /// {@macro theme_config}
  const ThemeConfig({
    required this.lightScheme,
    required this.darkScheme,
    required this.defaultThemeState,
    this.useMaterial3,
    this.textTheme,
    this.builder,
  });

  /// Color scheme for light theme.
  final ColorScheme lightScheme;

  /// Color scheme for dark theme.
  final ColorScheme darkScheme;

  /// Default [ThemeState] to use when theme is not saved.
  final ThemeState defaultThemeState;

  /// `true` if we want to use Material3 theme.
  final bool? useMaterial3;

  /// [TextTheme] to be used.
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

  /// Create a [ThemeData] based on the colors in the given [scheme] and
  /// text styles of the optional [textTheme].
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

  /// [ThemeData] generated from provided config and [lightScheme].
  ThemeData get lightTheme => fromScheme(lightScheme);

  /// [ThemeData] generated from provided config and [darkScheme].
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
