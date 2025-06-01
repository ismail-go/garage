import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garage/ui/main/main_screen.dart';
import 'package:garage/core/firebase/firebase_options.dart';
import 'package:garage/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // useMaterial3: true, // Commented out to resolve potential linter error with older Flutter versions.
                           // Uncomment if your Flutter version supports it and you intend to use Material 3.
      home: MainScreen(),
    );
  }
}
