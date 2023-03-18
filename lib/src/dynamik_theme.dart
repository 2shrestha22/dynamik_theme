import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamik_theme/src/theme_config.dart';
import 'package:dynamik_theme/src/theme_type.dart';
import 'package:flutter/material.dart';

class DynamikThemeBuilder extends StatefulWidget {
  const DynamikThemeBuilder({
    super.key,
    required this.defaultTheme,
    required this.config,
    required this.builder,
  });

  // static DynamikTheme of(BuildContext context) =>
  //     context.dependOnInheritedWidgetOfExactType<DynamikTheme>()
  //         as DynamikTheme;

  /// ThemeType when theme is not saved yet.
  final ThemeType defaultTheme;
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
  late ThemeType themeType;

  late final _storage = ThemeConfig.storage;

  @override
  void initState() {
    super.initState();
    themeType = _storage.read() ?? widget.defaultTheme;
  }

  void onThemeTypeChange(ThemeType value) {
    if (themeType == value) return;

    setState(() {
      themeType = value;
    });
    _storage.write(value);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return DynamikTheme(
        config: widget.config,
        themeType: themeType,
        onThemeTypeChange: onThemeTypeChange,
        child: Builder(builder: (context) {
          final themeType = DynamikTheme.of(context).themeType;
          final config = DynamikTheme.of(context).config;

          switch (themeType) {
            case ThemeType.light:
              return widget.builder(
                config.lightTheme,
                config.darkTheme,
                ThemeMode.light,
              );

            case ThemeType.dark:
              return widget.builder(
                config.lightTheme,
                config.darkTheme,
                ThemeMode.dark,
              );

            case ThemeType.dynamik:
              return widget.builder(
                lightDynamic == null
                    ? config.lightTheme
                    : config.fromScheme(lightDynamic),
                darkDynamic == null
                    ? config.darkTheme
                    : config.fromScheme(darkDynamic),
                ThemeMode.system,
              );
          }
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
    required this.themeType,
    required super.child,
  });

  final ThemeType themeType;
  final ThemeConfig config;
  final void Function(ThemeType value) onThemeTypeChange;

  @override
  bool updateShouldNotify(covariant DynamikTheme oldWidget) {
    return themeType != oldWidget.themeType;
  }

  static DynamikTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamikTheme>();
  }

  static DynamikTheme of(BuildContext context) {
    final DynamikTheme? result = maybeOf(context);
    assert(result != null, 'No DynamicTheme found in the context.');
    return result!;
  }

  void setTheme(ThemeType value) => onThemeTypeChange(value);
}
