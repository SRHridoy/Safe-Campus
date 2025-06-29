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
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(24),
                          constraints: BoxConstraints(maxWidth: 400),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.report, color: Colors.redAccent, size: 32),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text('Complaint Details',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.green[900]),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 28, thickness: 1.2, color: Colors.green[200]),
                                SizedBox(height: 8),
                                _detailRow('Student Name', (complaint['name'] ?? '').toString()),
                                _detailRow('Student ID', (complaint['studentId'] ?? '').toString()),
                                if (complaint['department'] != null)
                                  _detailRow('Department', (complaint['department']).toString()),
                                if (complaint['phone'] != null)
                                  _detailRow('Mobile', (complaint['phone']).toString()),
                                if (complaint['accused'] != null)
                                  _detailRow('Accused', (complaint['accused']).toString()),
                                if (complaint['datetime'] != null)
                                  _detailRow('Date & Time', (complaint['datetime']).toString()),
                                if (complaint['location'] != null)
                                  _detailRow('Location', (complaint['location']).toString()),
                                SizedBox(height: 14),
                                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 16)),
                                Container(
                                  margin: EdgeInsets.only(top: 4, bottom: 10),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      (complaint['description'] ?? '').toString(),
                                      style: TextStyle(fontSize: 15),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: (complaint['status'] ?? 0) == 1 ? Colors.orange : Colors.grey, size: 20),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text('Status: ', style: TextStyle(fontWeight: FontWeight.w600)),
                                    ),
                                    Flexible(
                                      child: Text(
                                        (complaint['status'] ?? 0) == 1 ? 'In Progress' : 'No Progress',
                                        style: TextStyle(
                                          color: (complaint['status'] ?? 0) == 1 ? Colors.orange[800] : Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                if (complaint['imageUrl'] != null && complaint['imageUrl'].toString().isNotEmpty) ...[
                                  SizedBox(height: 18),
                                  Text('Attached Evidence:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 16)),
                                  SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      complaint['imageUrl'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Center(child: Text('Image not found')),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(height: 18),
                                  Text('Attached Evidence: None', style: TextStyle(color: Colors.grey[700])),
                                ],
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: Icon(
                                        (complaint['status'] ?? 0) == 1 ? Icons.cancel : Icons.check_circle,
                                        color: (complaint['status'] ?? 0) == 1 ? Colors.orange : Colors.green,
                                      ),
                                      label: Text(
                                        (complaint['status'] ?? 0) == 1 ? 'Mark as Not In Progress' : 'Mark as In Progress',
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance.collection('complaints').doc(complaints[index].id).update({
                                          'status': (complaint['status'] ?? 0) == 1 ? 0 : 1,
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green[900])),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
