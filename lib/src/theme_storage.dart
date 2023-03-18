import 'package:dynamik_theme/src/theme_type.dart';

/// Interface which is used to persist and retrieve state changes.
abstract class ThemeStorage {
  /// Returns saved theme.
  ThemeType? read();

  /// Persists theme.
  Future<void> write(ThemeType type);

  /// Deletes theme info.
  Future<void> delete();
}

class InMemoryThemeStorage extends ThemeStorage {
  ThemeType? _themeType;

  @override
  Future<void> delete() async {
    _themeType = null;
  }

  @override
  ThemeType? read() {
    return _themeType;
  }

  @override
  Future<void> write(ThemeType type) async {
    _themeType = type;
  }
}
