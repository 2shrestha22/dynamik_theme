import 'package:dynamik_theme/src/theme_state.dart';

/// Interface which is used to persist and retrieve state changes.
abstract class ThemeStorage {
  /// Returns saved theme.
  ThemeState? read();

  /// Persists theme.
  Future<void> write(ThemeState type);

  /// Deletes theme info.
  Future<void> delete();
}

class InMemoryThemeStorage extends ThemeStorage {
  ThemeState? _themeType;

  @override
  Future<void> delete() async {
    _themeType = null;
  }

  @override
  ThemeState? read() {
    return _themeType;
  }

  @override
  Future<void> write(ThemeState type) async {
    _themeType = type;
  }
}
