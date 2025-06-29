import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../services/location_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _showSuccessCard = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Call SOS message sending when the page starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendSosMessage();
    });
  }

  Future<void> _sendSosMessage() async {
    setState(() {
      _sending = true;
    });
    final locationData = await LocationService().getUserLocation();
    String locationUrl = '';
    if (locationData['latitude'] != null && locationData['longitude'] != null) {
      locationUrl = 'https://www.google.com/maps/search/?api=1&query=${locationData['latitude']},${locationData['longitude']}';
    } else {
      locationUrl = 'Location unavailable';
    }
    final now = DateTime.now();
    final message =
        'SOS! I’m in danger due to a ragging incident. My live location: $locationUrl. Time: $now. Please help immediately.';

    // Fetch current user's name and studentId from Firestore
    final user = FirebaseAuth.instance.currentUser;
    String? name;
    String? studentId;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('user_infos').doc(user.uid).get();
      if (userDoc.exists) {
        name = userDoc['name'];
        studentId = userDoc['studentId'];
      }
    }

    // Store in Firestore
    await FirebaseFirestore.instance.collection('sos_alerts').add({
      'name': name ?? '',
      'studentId': studentId ?? '',
      'latitude': locationData['latitude'],
      'longitude': locationData['longitude'],
      'city': locationData['city'],
      'country': locationData['country'],
      'timestamp': now,
      'message': message,
    });
    setState(() {
      _sending = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('SOS message sent and stored in Firestore!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onSosPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.emoji_emotions, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Take a deep breath. Help is on the way! Stay calm, you are strong.',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        duration: const Duration(seconds: 4),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    return WillPopScope(
      onWillPop: () async {
        final userType = storage.read('userType') ?? 'user';
        final route = userType == 'admin' ? '/admin' : '/user';
        Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade700,
          title: const Text('SOS', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final userType = storage.read('userType') ?? 'user';
              final route = userType == 'admin' ? '/admin' : '/user';
              Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Emergency SOS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _sending ? null : _sendSosMessage,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(60),
                    backgroundColor: Colors.red.shade700,
                    elevation: 10,
                    shadowColor: Colors.red,
                  ),
                  child: _sending
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  color: Colors.green.shade50,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 36),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Success!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your location has been sent to the Proctorial Body!',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
