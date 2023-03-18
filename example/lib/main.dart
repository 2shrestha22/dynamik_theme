import 'dart:developer';

import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
        lightScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        darkScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      defaultTheme: ThemeType.dark,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamik Theme'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.create),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: ThemeType.values
                  .map((e) => TextButton(
                        onPressed: () {
                          DynamikTheme.of(context).setTheme(e);
                        },
                        child: Text(e.name),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
