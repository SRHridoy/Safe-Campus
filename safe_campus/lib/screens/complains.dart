import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ComplainsScreen extends StatefulWidget {
  const ComplainsScreen({Key? key}) : super(key: key);

  @override
  State<ComplainsScreen> createState() => _ComplainsScreenState();
}

class _ComplainsScreenState extends State<ComplainsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('complaints').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading complaints'));
        }
        final complaints = snapshot.data?.docs ?? [];
        if (complaints.isEmpty) {
          return Center(child: Text('No complaints found.'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index].data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.report, color: Colors.redAccent),
                  backgroundColor: Colors.red[50],
                ),
                title: Text(
                  ((complaint['name'] ?? '').toString()) + ' (' + ((complaint['studentId'] ?? '').toString()) + ')',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text((complaint['description'] ?? '').toString()),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width < 350 ? 8 : 12,
                              vertical: MediaQuery.of(context).size.width < 350 ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: (complaint['status'] ?? 0) == 1 ? Colors.orange[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (complaint['status'] ?? 0) == 1 ? Colors.orange : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              (complaint['status'] ?? 0) == 1 ? 'In Process' : 'No Progress',
                              style: TextStyle(
                                color: (complaint['status'] ?? 0) == 1 ? Colors.orange[800] : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width < 350 ? 8 : 16),
                        Flexible(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (complaint['status'] ?? 0) == 1 ? Colors.green : Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width < 350 ? 8 : 16,
                                vertical: MediaQuery.of(context).size.width < 350 ? 6 : 8,
                              ),
                            ),
                            icon: Icon(
                              (complaint['status'] ?? 0) == 1 ? Icons.check_circle : Icons.play_circle_fill,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width < 350 ? 18 : 22,
                            ),
                            label: Text(
                              (complaint['status'] ?? 0) == 1 ? 'Mark as No Progress' : 'Mark In Process',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('complaints').doc(complaints[index].id).update({
                                'status': (complaint['status'] ?? 0) == 1 ? 0 : 1,
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Complaint Details'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Student Name: \\${(complaint['name'] ?? '').toString()}'),
                              Text('Student ID: \\${(complaint['studentId'] ?? '').toString()}'),
                              if (complaint['department'] != null)
                                Text('Department: \\${(complaint['department']).toString()}'),
                              if (complaint['phone'] != null)
                                Text('Mobile: \\${(complaint['phone']).toString()}'),
                              if (complaint['accused'] != null)
                                Text('Accused: \\${(complaint['accused']).toString()}'),
                              if (complaint['datetime'] != null)
                                Text('Date & Time: \\${(complaint['datetime']).toString()}'),
                              if (complaint['location'] != null)
                                Text('Location: \\${(complaint['location']).toString()}'),
                              SizedBox(height: 8),
                              Text('Description:'),
                              Text((complaint['description'] ?? '').toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Status: \\${((complaint['status'] ?? 0) == 1 ? 'In Progress' : 'No Progress')}'),
                              if (complaint['imageUrl'] != null && complaint['imageUrl'].toString().isNotEmpty) ...[
                                SizedBox(height: 8),
                                Text('Attached Evidence:'),
                                SizedBox(height: 6),
                                Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    complaint['imageUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Center(child: Text('Image not found')),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(height: 8),
                                Text('Attached Evidence: None'),
                              ],
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('complaints').doc(complaints[index].id).update({
                                'status': (complaint['status'] ?? 0) == 1 ? 0 : 1,
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              (complaint['status'] ?? 0) == 1 ? 'Mark as Not In Progress' : 'Mark as In Progress',
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
