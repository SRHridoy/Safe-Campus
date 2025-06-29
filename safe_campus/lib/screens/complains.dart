import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

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
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.25 * 255).toInt()),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withAlpha((0.3 * 255).toInt()), width: 1.2),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.report, color: Colors.redAccent),
                        backgroundColor: Colors.white.withAlpha((0.7 * 255).toInt()),
                      ),
                      title: Text(
                        ((complaint['name'] ?? '').toString()) + ' (' + ((complaint['studentId'] ?? '').toString()) + ')',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withAlpha((0.85 * 255).toInt())),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text((complaint['description'] ?? '').toString(), style: TextStyle(color: Colors.black.withAlpha((0.7 * 255).toInt()))),
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
                  ),
                ),
              ));
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
