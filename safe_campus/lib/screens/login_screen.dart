import 'package:flutter/material.dart';
import 'report_screen.dart';
import '../services/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _authService = AuthenticationService();
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(onChanged: (value) => email = value),
          TextField(onChanged: (value) => password = value, obscureText: true),
          ElevatedButton(
            onPressed: () async {
              await _authService.signIn(email, password);
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (_) => ReportScreen()));
            },
            child: Text('লগইন'),
          ),
        ],
      ),
    );
  }
}