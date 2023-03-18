import 'dart:math';

import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const _space = SizedBox(height: 16, width: 16);
final _colors = List.generate(
    8,
    (index) =>
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamikThemeBuilder(
      config: ThemeConfig(
        useMaterial3: true,
        lightScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        darkScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        defaultThemeState: SimpleThemeType.dynamik.themeData,
        builder: (themeData) {
          return themeData.copyWith(
            appBarTheme: const AppBarTheme(centerTitle: true),
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
              spacing: 10,
              children: SimpleThemeType.values
                  .map((e) => InputChip(
                        label: Text(e.name),
                        selected: themeState == e.themeData,
                        onPressed: () {
                          DynamikTheme.of(context).setTheme(e.themeData);
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
              spacing: 10,
              children: ColorMode.values
                  .map(
                    (e) => InputChip(
                      label: Text(e.name),
                      selected: themeState.colorMode == e,
                      onPressed: themeState.colorMode != ColorMode.dynamik
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
          ],
        ),
      ),
    );
  }
}
