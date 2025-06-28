import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Icon prefixIcon;
  final Color iconColor = Colors.green;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const CustomTextField({super.key,required this.labelText, required this.prefixIcon, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        prefixIconColor: iconColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      controller: controller,
      keyboardType: keyboardType,
    );
  }
}
