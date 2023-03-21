import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamik_theme/src/theme_config.dart';
import 'package:dynamik_theme/src/theme_state.dart';
import 'package:flutter/material.dart';

/// {@template dynamik_theme}
/// [DynamikTheme] provides [ThemeData] and [ThemeMode] based on color scheme
/// or custom color.
///
/// Wrap [MaterialApp] with [DynamikTheme] and use [ThemeData] for light/dark
/// mode and [ThemeMode].
/// {@endtemplate}
class DynamikTheme extends StatefulWidget {
  /// {@macro dynamik_theme}
  const DynamikTheme({
    super.key,
    required this.config,
    required this.builder,
  });

  /// {@macro inherited_dynamik_theme_of}
  static InheritedDynamikTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDynamikTheme>()
          as InheritedDynamikTheme;

  /// {@macro theme_config}
  final ThemeConfig config;

  /// ThemeData theme, ThemeData darkTheme, ThemeMode themeMode.
  final Widget Function(
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  @override
  State<DynamikTheme> createState() => _DynamikThemeState();
}

class _DynamikThemeState<T> extends State<DynamikTheme> {
  late final _storage = ThemeConfig.storage;
  late ThemeState themeState =
      _storage.read() ?? widget.config.defaultThemeState;

  void onStateUpdate(ThemeState Function(ThemeState state) updater) {
    final newState = updater(themeState);
    if (themeState == newState) return;
    setState(() {
      themeState = newState;
    });
    _storage.write(newState);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return InheritedDynamikTheme(
        config: widget.config,
        themeState: themeState,
        onStateUpdate: onStateUpdate,
        child: Builder(builder: (context) {
          final themeState = InheritedDynamikTheme.of(context).themeState;
          final config = InheritedDynamikTheme.of(context).config;

          late ThemeData themeData;
          late ThemeData darkThemeData;

          if (themeState.colorMode == ColorMode.dynamik) {
            // use dynamic theming
            themeData = lightDynamic == null
                ? config.lightTheme
                : config.fromScheme(lightDynamic);
            darkThemeData = darkDynamic == null
                ? config.darkTheme
                : config.fromScheme(darkDynamic);
          } else if (themeState.colorMode == ColorMode.custom &&
              themeState.seed != null) {
            // create new dynamic theme from custom color
            themeData = config.fromScheme(
              ColorScheme.fromSeed(seedColor: themeState.seed!),
            );
            darkThemeData = config.fromScheme(
              ColorScheme.fromSeed(
                seedColor: themeState.seed!,
                brightness: Brightness.dark,
              ),
            );
          } else {
            // use default theming from theme config scheme.
            themeData = config.lightTheme;
            darkThemeData = config.darkTheme;
          }
          return widget.builder(
            themeData,
            darkThemeData,
            themeState.themeMode,
          );
        }),
      );
    });
  }
}

/// {@template inherited_dynamik_theme}
/// [InheritedWidget] that allows to update [ThemeState] from anywhere in the
/// widget tree.
/// {@endtemplate}
class InheritedDynamikTheme extends InheritedWidget {
  /// {@macro inherited_dynamik_theme}
  const InheritedDynamikTheme({
    super.key,
    required this.config,
    required this.themeState,
    required this.onStateUpdate,
    required super.child,
  });

  /// {@macro theme_state}
  final ThemeState themeState;

  /// {@macro theme_config}
  final ThemeConfig config;

  /// Higher order function that allows to update [ThemeState].
  final void Function(ThemeState Function(ThemeState) updater) onStateUpdate;

  @override
  bool updateShouldNotify(covariant InheritedDynamikTheme oldWidget) {
    return themeState != oldWidget.themeState;
  }

  static InheritedDynamikTheme? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDynamikTheme>();
  }

  /// {@template inherited_dynamik_theme_of}
  /// Method that allows widgets to access a [InheritedDynamikTheme] instance.
  ///
  /// ```dart
  /// DynamikTheme.of(context);
  /// ```
  /// {@endtemplate}
  static InheritedDynamikTheme of(BuildContext context) {
    final InheritedDynamikTheme? result = _maybeOf(context);
    assert(result != null, 'No DynamicTheme found in the context.');
    return result!;
  }

  /// Set new [ThemeState].
  void setTheme(ThemeState value) => onStateUpdate((_) => value);

  /// Set new [ThemeMode] without chaning other values in [ThemeState].
  void setThemeMode(ThemeMode value) => onStateUpdate(
        (state) => state.copyWith(themeMode: value),
      );

  /// Set ColorMode.dynamik
  void setDynamikColorMode() => onStateUpdate(
        (state) => state.copyWith(colorMode: ColorMode.dynamik),
      );

  /// Set ColorMode.custom
  void setCustomColorMode(Color value) => onStateUpdate(
        (state) => state.copyWith(seed: value, colorMode: ColorMode.custom),
      );
}
