import 'package:flutter/material.dart';
import 'package:garage/ui/home/home_screen.dart';

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
            backgroundColor: Colors.white,
            selectedItemColor: ThemeData().primaryColor,
            unselectedItemColor: ThemeData().disabledColor,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: ThemeData().primaryColor,
            titleTextStyle: TextStyle(
              color: ThemeData().primaryColorLight,
              fontSize: 24,
            ),
          )),
      home: HomeScreen(),
    );
  }
}
