<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Easy to use Dynamic Theme for Flutter with automatic persistence support.

## Supported Themes

- Light Theme
- Dark Theme
- System Mode
- Dynamic Mode
- Custom Color

![](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzZjZTUzMmU2MzhiNzg3NmIzYzQ5OTE0MWFjYzdkY2MyMzc5NzUzOCZjdD1n/nBoQ3rfwkGv7XOSGjL/giphy.gif)
## Usage

```dart
void main() {
  /// Set ThemeStorage. If not set InMemoryThemeStorage will be used.
  ThemeConfig.storage = InMemoryThemeStorage();
  runApp(const MyApp());
}
```

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamikTheme(
      config: ThemeConfig(
        useMaterial3: true,
        // You can also generate color schemes from:
        // https://m3.material.io/theme-builder#/custom
        lightScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        darkScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        defaultThemeState: SimpleThemeType.dynamik.themeData,
        builder: (themeData) {
          // Add more customization on ThemeData.
          return themeData.copyWith(
            appBarTheme: const AppBarTheme(centerTitle: true),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
      builder: (theme, darkTheme, themeMode) {
        return MaterialApp(
          themeMode: themeMode,
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: const Home(),
        );
      },
    );
  }
}
```
Implementing `ThemeStorage` for persistence. You can use Hive, SharedPreferences or any database of your choice.
```dart
class InMemoryThemeStorage implements ThemeStorage {
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
```

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:
- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Fix typos/grammar mistakes
- Update the documentation / add examples
- Implement new features by making a pull-request

