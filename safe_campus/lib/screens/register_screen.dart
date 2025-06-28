import 'package:flutter/material.dart';
import 'package:safe_campus/services/login_service.dart';
import '../custom_widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> departments = [
    'CSE', 'ECE', 'EEE', 'Agri', 'DVM', 'MEE', 'FPE', 'Arch',
    'Fisheries', 'English', 'Sociology', 'Business Studies'
  ];

  String? selectedDepartment = 'CSE';

  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  final LoginService _authService = LoginService();

  void _signup() async {
    setState(() => _isLoading = true);

    try {
      // Validation
      if (studentIdController.text.trim().isEmpty ||
          nameController.text.trim().isEmpty ||
          selectedDepartment == null || selectedDepartment!.isEmpty ||
          phoneController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fill in all fields.')),
          );
        }
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match.')),
          );
        }
        return;
      }

      // Firebase Signup Call
      String? result = await _authService.signup(
        studentId: studentIdController.text.trim(),
        name: nameController.text.trim(),
        department: selectedDepartment ?? '',
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        if (result == null) {
          // Registration successful
          final snackBar = SnackBar(
            content: Text(
              'Registration successful! Welcome, ${nameController.text}!',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          await Future.delayed(Duration(seconds: 2));
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    studentIdController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green[200],
                child: Icon(Icons.person_add_alt_1, size: 40, color: Colors.green[800]),
              ),
              SizedBox(height: 24),
              CustomTextField(
                labelText: 'Student ID',
                prefixIcon: Icon(Icons.badge, color: Colors.green),
                controller: studentIdController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person, color: Colors.green),
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.school, color: Colors.green),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                items: departments.map((dept) => DropdownMenuItem(
                  value: dept,
                  child: Text(dept),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
                dropdownColor: Colors.green[50],
                iconEnabledColor: Colors.green,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone, color: Colors.green),
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.green),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.green),
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline, color: Colors.green),
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 24),
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
                  onPressed: _signup,
                  child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
