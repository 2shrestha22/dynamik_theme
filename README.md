<img src="https://raw.githubusercontent.com/2shrestha22/dynamik_theme/main/assets/banner.png"/>


`dynamik_theme` lets you easily set theme mode or custom color. It supports dynamic color on supported platforms and it also persists theme state using storage of your choice.

<p>
<a href="https://pub.dev/packages/dynamik_theme"><img src="https://img.shields.io/pub/v/dynamik_theme.svg" alt="Pub"></a>
<a href="https://github.com/2shrestha22/dynamik_theme"><img src="https://img.shields.io/github/stars/2shrestha22/dynamik_theme.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

- Light Mode - based on light color scheme
- Dark Mode - based on dark color scheme
- System Mode - automatic light or dark theming based on light/dark color scheme
- Dynamic Color - uses `dynamic_color` to automatically get color from device
- Custom Color - set any color you want

![](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzZjZTUzMmU2MzhiNzg3NmIzYzQ5OTE0MWFjYzdkY2MyMzc5NzUzOCZjdD1n/nBoQ3rfwkGv7XOSGjL/giphy.gif)
## Usage

### Setup Storage
Implement `ThemeStorage` for persistence.

```dart
class HiveStorage extends ThemeStorage {
  final box = Hive.box<String>(_boxName);
  final key = 'theme';
  @override
  Future<void> delete() async {
    await box.clear();
  }

  @override
  ThemeState? read() {
    final res = box.get(key);
    if (res == null) return null;
    return ThemeState.fromJson(res);
  }

  @override
  Future<void> write(ThemeState state) async {
    await box.put(key, state.toJson());
  }
}
```

You can also use SharedPreferences or any database of your choice.

```dart
void main() {
  // Initialize hive.
  await Hive.initFlutter();
  await Hive.openBox<String>(_boxName);

  // Set ThemeStorage. If not set InMemoryThemeStorage will be used.
  ThemeConfig.storage = HiveStorage();

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

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:
- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Fix typos/grammar mistakes
- Update the documentation / add examples
- Implement new features by making a pull-request

