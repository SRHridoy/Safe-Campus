import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _proofFile;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _accusedController = TextEditingController();
  final TextEditingController _datetimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _deptController.dispose();
    _phoneController.dispose();
    _accusedController.dispose();
    _datetimeController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _proofFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    String cloudName = 'dkyl04a4w'; // Replace with your Cloudinary cloud name
    String uploadPreset = 'safe_campus'; // Replace with your Cloudinary upload preset

    var url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var jsonData = json.decode(utf8.decode(responseData));
        return jsonData['secure_url'];
      } else {
        print('Failed to upload image: \\${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String? imageUrl;
      if (_proofFile != null) {
        imageUrl = await uploadImageToCloudinary(_proofFile!);
      }
      // Store complaint in Firestore
      await FirebaseFirestore.instance.collection('complaints').add({
        'name': _nameController.text.trim(),
        'studentId': _idController.text.trim(),
        'department': _deptController.text.trim(),
        'phone': _phoneController.text.trim(),
        'accused': _accusedController.text.trim(),
        'datetime': _datetimeController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descController.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully ✅')),
      );
      _formKey.currentState!.reset();
      _proofFile = null;
      setState(() {});
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(

      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.08),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField("Your Name", "required", controller: _nameController),
                      _buildTextField("ID Number", "required", controller: _idController),
                      _buildTextField("Department", "required", controller: _deptController),
                      _buildTextField("Mobile Number", "required", isPhone: true, controller: _phoneController),
                      Divider(height: 30, color: Colors.green[200]),
                      _buildTextField("Accused Student Name / ID", "required", controller: _accusedController),
                      _buildTextField("Date & Time of Incident", "e.g., 25 June, 10:30AM", controller: _datetimeController),
                      _buildTextField("Location of Incident", "required", controller: _locationController),
                      _buildTextField("Detailed Description of Incident", "required", maxLines: 5, controller: _descController),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.08),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _proofFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_proofFile!, height: 140, fit: BoxFit.cover),
                            )
                          : Text("No evidence attached", style: TextStyle(color: Colors.green[700])),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.attach_file, color: Colors.white),
                        label: Text("Attach Evidence", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.redAccent.shade100,
                  ),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        )
                      : Text("Submit Complaint", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                SizedBox(height: 12),
                // Cancel button removed as requested
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {bool isPhone = false, int maxLines = 1, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please fill out this field';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w600),
          hintStyle: TextStyle(color: Colors.green[400]),
          filled: true,
          fillColor: Colors.green[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
          ),
        ),
      ),
    );
  }
}
