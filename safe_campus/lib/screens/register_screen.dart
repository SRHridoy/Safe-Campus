import 'package:flutter/material.dart';
import '../custom_widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> departments = [
    'CSE', 'ECE', 'EEE', 'Agri', 'DVM', 'MEE', 'FPE', 'Arch', 'Fisheries', 'English', 'Sociology', 'Business Studies'
  ];
  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person, color: Colors.green),
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
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.green),
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.green),
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline, color: Colors.green),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {},
                  child: Text('Register', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

