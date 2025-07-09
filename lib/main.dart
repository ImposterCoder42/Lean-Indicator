import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/splash_screen.dart';
import 'package:active_gauges/themes/main_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(RideDataPointAdapter());
  Hive.registerAdapter(SingleRideAdapter());

  await Hive.openBox<SingleRide>('rides');

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
