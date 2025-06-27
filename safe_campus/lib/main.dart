import 'package:flutter/material.dart';
import 'package:safe_campus/screens/bottom_nav_bar.dart';
import 'package:safe_campus/screens/user_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBarAssigment(),
    );
  }
}
