import 'package:active_gauges/splash_screen.dart';
import 'package:active_gauges/themes/main_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acive Gauges',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // choose mode or system
      home: const SplashScreen(),
    );
  }
}
