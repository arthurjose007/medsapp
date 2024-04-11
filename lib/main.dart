import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meds/firebase_options.dart';
import 'package:meds/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(241, 250, 251, 1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 241, 250, 251),
        ),
        colorSchemeSeed: const Color.fromRGBO(7, 82, 96, 1),
      ),
      home: const SplashScreen(),
    );
  }
}
