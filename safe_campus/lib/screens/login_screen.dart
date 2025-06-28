import 'package:flutter/material.dart';
import 'package:safe_campus/custom_widgets/custom_text_field.dart';

import '../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _loginService = LoginService();
  bool _isLoading = false;

  void login() async {
    setState(() => _isLoading = true);
    String? result = await _loginService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (result == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (result == 'user') {
      Navigator.pushReplacementNamed(context, '/user');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Login failed')),
      );
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.green[200],
                child: Icon(Icons.lock_outline, size: 48, color: Colors.green[800]),
              ),
              SizedBox(height: 32),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Login to your account',
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
              ),
              SizedBox(height: 32),

              CustomTextField(labelText: 'Email', prefixIcon: Icon(Icons.email, color: Colors.green), controller: emailController),
              SizedBox(height: 16),
              CustomTextField(labelText: 'Password', prefixIcon: Icon(Icons.lock, color: Colors.green), controller: passwordController),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.green[700])),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: login,
                        child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
              ),
              SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: TextStyle(color: Colors.green[700])),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to register screen
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Create New Account', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
