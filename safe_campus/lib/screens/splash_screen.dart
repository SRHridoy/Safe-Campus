import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safe_campus/screens/location_test_screen.dart';
import 'package:safe_campus/screens/login_screen.dart';
import 'package:safe_campus/screens/register_screen.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Safe Campus',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Anti-Ragging App',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

