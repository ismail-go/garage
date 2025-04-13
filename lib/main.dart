import 'package:flutter/material.dart';
import 'package:garage/ui/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          //scania white
          scaffoldBackgroundColor: Color(0xFFFAFAFA),
          //scania blue
          primaryColor: Color(0xFF041E42),
          //scania white
          primaryColorLight: Color(0xFFFAFAFA),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white.withValues(alpha: .9),
            selectedItemColor: ThemeData().primaryColor,
            unselectedItemColor: ThemeData().disabledColor,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white70),
            backgroundColor: ThemeData().primaryColor.withValues(alpha: .9),
            titleTextStyle: TextStyle(
              color: ThemeData().primaryColorLight,
              fontSize: 24,
            ),
          )),
      home: MainScreen(),
    );
  }
}
