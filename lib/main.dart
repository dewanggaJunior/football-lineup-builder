import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const TimnasApp());

class TimnasApp extends StatelessWidget {
  const TimnasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}