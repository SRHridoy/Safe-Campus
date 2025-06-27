import 'package:flutter/material.dart';

class CenterTextScreen extends StatefulWidget {
  const CenterTextScreen({super.key});

  @override
  State<CenterTextScreen> createState() => _CenterTextScreenState();
}

class _CenterTextScreenState extends State<CenterTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hello World',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
