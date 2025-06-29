import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // GetStorage import করো

class EmergencyContacts extends StatelessWidget {
  final storage = GetStorage(); // ✅ এখানে instance তৈরি করো

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Proctorial Body & Safety Contacts',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow('Chief Proctor', '+8801711-123456', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Proctor Office', '+8801711-654321', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Security In-Charge', '+8801711-789012', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Medical Center', '+8801711-345678', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Police (Kawnia)', '999 or +8801711-112233', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Fire Service', '199', context),
                      SizedBox(height: 8),
                      _buildInfoRow('Ambulance', '+8801711-998877', context),
                      Spacer(),

                      // Logout Option
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            storage.erase(); // logout
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width < 350 ? 13 : 16;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
