import 'package:dynamik_theme/src/theme_storage.dart';
import 'package:dynamik_theme/src/theme_type.dart';
import 'package:flutter/material.dart';

/// Extend this class to add further customization on theme like, font styles.
///
/// Example:
///
/// ``` dart
/// class AppTheme extends ThemeConfig {
///   AppTheme({required super.lightScheme, required super.darkScheme});
///
///   @override
///   ThemeData fromScheme(ColorScheme scheme) {
///     final baseTheme = ThemeData.from(colorScheme: scheme);
///     final textTheme = baseTheme.textTheme;
///
///     return baseTheme.copyWith(
///       textTheme: GoogleFonts.plusJakartaSansTextTheme(
///         baseTheme.textTheme.copyWith(
///           headlineSmall: textTheme.headlineSmall?.copyWith(
///             fontWeight: FontWeight.bold,
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class ThemeConfig {
  ThemeConfig({
    required this.lightScheme,
    required this.darkScheme,
    required this.defaultThemeState,
  });

  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final ThemeState defaultThemeState;

  /// Override [fromScheme] to add further customization like adding Fonts.
  ThemeData fromScheme(ColorScheme scheme) {
    return ThemeData.from(colorScheme: scheme);
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
