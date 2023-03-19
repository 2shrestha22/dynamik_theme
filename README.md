Easy to use Dynamic Theme for Flutter with automatic persistence support.

<p>
<a href="https://pub.dev/packages/dynamik_theme"><img src="https://img.shields.io/pub/v/dynamik_theme.svg" alt="Pub"></a>
<a href="https://github.com/2shrestha22/dynamik_theme"><img src="https://img.shields.io/github/stars/2shrestha22/dynamik_theme.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

## Supported Themes Modes

- Light Theme
- Dark Theme
- System Mode
- Dynamic Mode
- Custom Color

![](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzZjZTUzMmU2MzhiNzg3NmIzYzQ5OTE0MWFjYzdkY2MyMzc5NzUzOCZjdD1n/nBoQ3rfwkGv7XOSGjL/giphy.gif)
## Usage

### Setup Storage
```dart
void main() {
  /// Set ThemeStorage. If not set InMemoryThemeStorage will be used.
  ThemeConfig.storage = InMemoryThemeStorage();
  runApp(const MyApp());
}
```

### Use `DynamikTheme`
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
        defaultThemeState: SimpleThemeType.dynamik.themeState,
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
### Update Theme
Update theme with
```dart
// Set new theme with provided ThemeState.
DynamikTheme.of(context).setTheme(themeState);

// Change ThemeMode. ThemeMode.light or ThemeMode.dark
// or ThemeMode.system.
DynamikTheme.of(context).setThemeMode(e);

// Set dynamic theme mode. Automatically sets color from device.
//(not supported on iOS)
DynamikTheme.of(context).setDynamikColorMode();

// Set custom color.
DynamikTheme.of(context).setCustomColorMode(e);

```
```dart
Wrap(
  runSpacing: 10,
  spacing: 10,
  children: SimpleThemeType.values
      .map((e) => InputChip(
            label: Text(e.name),
            selected: themeState == e.themeState,
            onPressed: () {
              // Update theme.
              DynamikTheme.of(context).setTheme(e.themeState);
            },
          ))
      .toList(),
),
```
See example for more.

### Set predefined list of ThemeState
You can also use `SimpleThemeType` which is predefined list of ThemeState. Or create you own list.
```dart
enum MyThemeType {
  dynamik(ThemeState(
    themeMode: ThemeMode.system,
    colorMode: ColorMode.dynamik,
  )),
  light(ThemeState(themeMode: ThemeMode.light)),
  dark(ThemeState(themeMode: ThemeMode.dark));

  const MyThemeType(this.themeState);
  final ThemeState themeState;
}
```

### Implement `ThemeStorage` for persistence
You can use Hive, SharedPreferences or any database of your choice.
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

