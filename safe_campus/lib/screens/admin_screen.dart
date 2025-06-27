import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Example data for reported complaints
  List<Map<String, dynamic>> complaints = [
    {
      'studentName': 'Alice Rahman',
      'studentId': '20231201',
      'complaint': 'Ragging in hostel block A',
      'status': 0, // 0: No Progress, 1: In Process
    },
    {
      'studentName': 'Biplob Hasan',
      'studentId': '20231202',
      'complaint': 'Verbal abuse in canteen',
      'status': 1,
    },
    {
      'studentName': 'Chowdhury Nayeem',
      'studentId': '20231203',
      'complaint': 'Physical threat in playground',
      'status': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.report, color: Colors.redAccent),
                backgroundColor: Colors.red[50],
              ),
              title: Text(
                complaint['studentName'] + ' (' + complaint['studentId'] + ')',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(complaint['complaint']),
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
                            color: complaint['status'] == 1 ? Colors.orange[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: complaint['status'] == 1 ? Colors.orange : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            complaint['status'] == 1 ? 'In Process' : 'No Progress',
                            style: TextStyle(
                              color: complaint['status'] == 1 ? Colors.orange[800] : Colors.grey[700],
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
                            backgroundColor: complaint['status'] == 1 ? Colors.green : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width < 350 ? 8 : 16,
                              vertical: MediaQuery.of(context).size.width < 350 ? 6 : 8,
                            ),
                          ),
                          icon: Icon(
                            complaint['status'] == 1 ? Icons.check_circle : Icons.play_circle_fill,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width < 350 ? 18 : 22,
                          ),
                          label: Text(
                            complaint['status'] == 1 ? 'Mark as No Progress' : 'Mark In Process',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () {
                            setState(() {
                              complaints[index]['status'] = complaint['status'] == 1 ? 0 : 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
