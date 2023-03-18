import 'package:dynamik_theme/src/theme_state.dart';

/// Interface which is used to persist and retrieve state changes.
abstract class ThemeStorage {
  /// Returns saved theme state.
  ThemeState? read();

  /// Saves theme to storage.
  Future<void> write(ThemeState state);

  /// Deletes saved theme state from storage.
  Future<void> delete();
}

class InMemoryThemeStorage extends ThemeStorage {
  ThemeState? _state;

  @override
  Future<void> delete() async {
    _state = null;
  }

  @override
  ThemeState? read() {
    return _state;
  }

  @override
  Future<void> write(ThemeState state) async {
    _state = state;
  }
}
