import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamik_theme/src/theme_config.dart';
import 'package:dynamik_theme/src/theme_state.dart';
import 'package:flutter/material.dart';

class DynamikThemeBuilder extends StatefulWidget {
  const DynamikThemeBuilder({
    super.key,
    required this.config,
    required this.builder,
  });

  // static DynamikTheme of(BuildContext context) =>
  //     context.dependOnInheritedWidgetOfExactType<DynamikTheme>()
  //         as DynamikTheme;

  /// ThemeType when theme is not saved yet.
  final ThemeConfig config;

  /// ThemeData theme, ThemeData darkTheme, ThemeMode themeMode.
  final Widget Function(
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  @override
  State<DynamikThemeBuilder> createState() => _DynamikThemeBuilderState();
}

class _DynamikThemeBuilderState<T> extends State<DynamikThemeBuilder> {
  late ThemeState themeState;

  late final _storage = ThemeConfig.storage;

  @override
  void initState() {
    super.initState();
    themeState = _storage.read() ?? widget.config.defaultThemeState;
  }

  void onThemeTypeChange(ThemeState value) {
    if (themeState == value) return;

    setState(() {
      themeState = value;
    });
    _storage.write(value);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return DynamikTheme(
        config: widget.config,
        themeState: themeState,
        onThemeTypeChange: onThemeTypeChange,
        child: Builder(builder: (context) {
          final themeState = DynamikTheme.of(context).themeState;
          final config = DynamikTheme.of(context).config;

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

class DynamikTheme extends InheritedWidget {
  const DynamikTheme({
    required this.onThemeTypeChange,
    super.key,
    required this.config,
    required this.themeState,
    required super.child,
  });

  final ThemeState themeState;
  final ThemeConfig config;
  final void Function(ThemeState value) onThemeTypeChange;

  @override
  bool updateShouldNotify(covariant DynamikTheme oldWidget) {
    return themeState != oldWidget.themeState;
  }

  static DynamikTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamikTheme>();
  }

  static DynamikTheme of(BuildContext context) {
    final DynamikTheme? result = maybeOf(context);
    assert(result != null, 'No DynamicTheme found in the context.');
    return result!;
  }

  void setTheme(ThemeState value) => onThemeTypeChange(value);
}
