import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContacts extends StatelessWidget {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSectionTitle('Proctor Section'),
                  _buildContactCard(
                    name: 'Prof. Dr. Md. Shamsuzzoha',
                    designation: 'Proctor (Additional Charge)',
                    phone: '+8801718617882',
                    email: 'ms_zoha2006@yahoo.com',
                  ),
                  _buildContactCard(
                    name: 'Prof. Rafia Akhtar',
                    designation: 'Assistant Proctor',
                    phone: '+8801727282204',
                    email: 'rafia_mgthstu@yahoo.com',
                  ),
                  _buildContactCard(
                    name: 'Prof. Dr. Abul Kalam',
                    designation: 'Assistant Proctor',
                    phone: '+8801718628988',
                    email: 'akalamhstu@gmail.com',
                  ),
                  SizedBox(height: 24),
                  _buildSectionTitle('Student Affairs & Advisory Division'),
                  _buildContactCard(
                    name: 'Prof. Dr. S.M. Emdadul Hassan',
                    designation: 'Director',
                    phone: '+8801713440465',
                    email: 'emdadul.hassan@yahoo.com',
                  ),
                  _buildContactCard(
                    name: 'Prof. Dr. Md. Abdul Alim',
                    designation: 'Assistant Director',
                    phone: '+8801714062618',
                    email: 'alim@hstu.ac.bd',
                  ),
                  _buildContactCard(
                    name: 'Prof. Dr. Md. Nizam Uddin',
                    designation: 'Assistant Director',
                    phone: '+8801712524222',
                    email: 'nizam_hstu@yahoo.com',
                  ),
                  _buildContactCard(
                    name: 'Md. Mahabur Rahman Chowdhury',
                    designation: 'Deputy Director',
                    phone: '+8801716696914',
                    email: 'mahabur2015@gmail.com',
                  ),
                  _buildContactCard(
                    name: 'Md. Zahidur Rahman Amin',
                    designation: 'Section Officer',
                    phone: '+8801712778400',
                    email: 'zahidadminhstu@gmail.com',
                  ),
                  _buildContactCard(
                    name: 'Md. Mamunur Rashid',
                    designation: 'Section Officer',
                    phone: '+8801717589749',
                    email: 'mamun_dinajpur@yahoo.com',
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String designation,
    required String phone,
    required String email,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity, // Full width of parent
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Height adjusts automatically
          children: [
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(designation),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () => _makePhoneCall(phone),
              child: Text(
                '📞 $phone',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            Text('✉️ $email'),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneUri');
    }
  }
}
