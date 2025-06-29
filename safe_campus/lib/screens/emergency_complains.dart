import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/notification_service.dart';

class EmergencyComplainsScreen extends StatefulWidget {
  @override
  State<EmergencyComplainsScreen> createState() => _EmergencyComplainsScreenState();
}

class _EmergencyComplainsScreenState extends State<EmergencyComplainsScreen> {
  int _lastDocCount = 0;
  @override
  void initState() {
    super.initState();
    NotificationService().init();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >();
    await androidImplementation?.requestNotificationsPermission();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sos_alerts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No SOS alerts found.'));
          }
          final docs = snapshot.data!.docs;
          // Notification logic: if new doc added
          if (docs.length > _lastDocCount) {
            NotificationService().showNotification(
              title: 'Help Needed!',
              body: 'I am ${docs.last['name']}  \n +${docs.last['message'] ?? ''}',
            );
          }
          _lastDocCount = docs.length;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unknown';
                    final studentId = data['studentId'] ?? '';
                    final message = data['message'] ?? '';
                    final lat = data['latitude'];
                    final lng = data['longitude'];
                    final hasValidLocation = lat != null && lng != null &&
                        lat is num && lng is num;
                    final locationUrl = hasValidLocation
                        ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng'
                        : null;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: Text('$name (${studentId.toString()})',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.isNotEmpty) Text(message),
                            if (hasValidLocation)
                              TextButton(
                                onPressed: () async {
                                  final uri = Uri.parse(locationUrl!);
                                  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  if (!launched) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Unable to launch the map application.')),
                                    );
                                  }
                                },
                                child: const Text('View Location on Map'),
                              ),
                          ],
                        ),
                        isThreeLine: true,
                        onLongPress: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Text('Delete Alert', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text('Are you sure you want to delete this SOS alert?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                  onPressed: () async {
                                    try {
                                      await docs[index].reference.delete();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('SOS alert deleted successfully.')),
                                      );
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to delete: $e')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logout logic (clear storage and navigate to login)
                      // If using GetStorage:
                      // import 'package:get_storage/get_storage.dart';
                      // GetStorage().erase();
                      // If using FirebaseAuth:
                      // import 'package:firebase_auth/firebase_auth.dart';
                      // await FirebaseAuth.instance.signOut();
                      // For now, just navigate:
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
              ),
            ],
          );
        },
      ),
    );
  }
}
