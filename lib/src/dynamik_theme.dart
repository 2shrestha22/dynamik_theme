import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamik_theme/src/theme_config.dart';
import 'package:dynamik_theme/src/theme_state.dart';
import 'package:flutter/material.dart';

class DynamikTheme extends StatefulWidget {
  const DynamikTheme({
    super.key,
    required this.config,
    required this.builder,
  });

  static InheritedDynamikTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDynamikTheme>()
          as InheritedDynamikTheme;

  /// ThemeType when theme is not saved yet.
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
  late ThemeState themeState;

  late final _storage = ThemeConfig.storage;

  @override
  void initState() {
    super.initState();
    themeState = _storage.read() ?? widget.config.defaultThemeState;
  }

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

class InheritedDynamikTheme extends InheritedWidget {
  const InheritedDynamikTheme({
    super.key,
    required this.config,
    required this.themeState,
    required this.onStateUpdate,
    required super.child,
  });

  final ThemeState themeState;
  final ThemeConfig config;
  final void Function(ThemeState Function(ThemeState) updater) onStateUpdate;

  @override
  bool updateShouldNotify(covariant InheritedDynamikTheme oldWidget) {
    return themeState != oldWidget.themeState;
  }

  static InheritedDynamikTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDynamikTheme>();
  }

  static InheritedDynamikTheme of(BuildContext context) {
    final InheritedDynamikTheme? result = maybeOf(context);
    assert(result != null, 'No DynamicTheme found in the context.');
    return result!;
  }

  void setTheme(ThemeState value) => onStateUpdate((_) => value);

  void setThemeMode(ThemeMode value) => onStateUpdate(
        (state) => state.copyWith(themeMode: value),
      );

  /// Sets ColorMode.dynamik
  void setDynamikColorMode() => onStateUpdate(
        (state) => state.copyWith(colorMode: ColorMode.dynamik),
      );

  // Sets ColorMode.custom
  void setCustomColorMode(Color value) => onStateUpdate(
        (state) => state.copyWith(seed: value, colorMode: ColorMode.custom),
      );
}
