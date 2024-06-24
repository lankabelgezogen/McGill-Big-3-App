import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mcgill_big_3/providers/workout_provider.dart';
import 'package:mcgill_big_3/screens/home_screen.dart';
import 'package:mcgill_big_3/screens/timer_screen.dart';
import 'package:mcgill_big_3/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McGill Big 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/timer': (context) => const TimerScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
