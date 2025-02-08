import 'dart:math';

import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

const _boxName = 'theme-storage';
const _space = SizedBox(height: 16, width: 16);
final _colors = List.generate(
  8,
  (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withAlpha(255),
);

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

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(_boxName);

  /// Set ThemeStorage. If not set InMemoryThemeStorage will be used.
  ThemeConfig.storage = HiveStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamikTheme(
      config: ThemeConfig(
        useMaterial3: true,
        // You can also create schemes from:
        // https://m3.material.io/theme-builder#/custom
        lightScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        darkScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        defaultThemeState: SimpleThemeType.dynamik.themeState,
        builder: (themeData) {
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = DynamikTheme.of(context).themeState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamik Theme'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.create),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Center(
              child: Text(
                'SimpleThemeType:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _space,
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: SimpleThemeType.values
                  .map((e) => InputChip(
                        label: Text(e.name),
                        selected: themeState == e.themeState,
                        onPressed: () {
                          DynamikTheme.of(context).setTheme(e.themeState);
                        },
                      ))
                  .toList(),
            ),
            _space,
            _space,
            Text(
              'Custom Colors:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _space,
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: ThemeMode.values
                  .map(
                    (e) => InputChip(
                      label: Text(e.name),
                      selected: themeState.themeMode == e,
                      onPressed: () {
                        DynamikTheme.of(context).setThemeMode(e);
                      },
                    ),
                  )
                  .toList(),
            ),
            _space,
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: ColorMode.values
                  .map(
                    (e) => InputChip(
                      label: Text(e.name),
                      selected: themeState.colorMode == e,
                      onPressed: e == ColorMode.dynamik
                          ? () {
                              DynamikTheme.of(context).setDynamikColorMode();
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
            _space,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              key: const ValueKey('value'),
              children: _colors.map((e) {
                return GestureDetector(
                  onTap: () {
                    DynamikTheme.of(context).setCustomColorMode(e);
                  },
                  child: CircleAvatar(
                    backgroundColor: e,
                  ),
                );
              }).toList(),
            ),
            _space,
            const Divider(),
            _space,
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                TextButton(onPressed: () {}, child: const Text('TextButton')),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image),
                  label: const Text('ElevatedButton'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('FilledButton'),
                ),
              ],
            ),
            _space,
            const TextField(),
            _space,
            const TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                errorText: 'ErrorText',
              ),
            ),
            _space,
            CheckboxListTile(
              title: const Text('CheckboxListTile'),
              value: true,
              onChanged: (_) {},
            ),
            RadioListTile(
              value: true,
              groupValue: true,
              onChanged: (_) {},
              title: const Text('RadioListTile'),
            ),
          ],
        ),
      ),
    );
  }
}
