import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/recording_service.dart';
// import '../services/location_service.dart';
import '../models/report_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  final RecordingService recordingService = RecordingService();
  // final LocationService locationService = LocationService();
  int shakeCount = 0;
  String accused = '', year = '', branch = '', description = '';

  @override
  void initState() {
    super.initState();
    recordingService.init();
    startShakeDetection();
  }

  void startShakeDetection() {
    accelerometerEvents.listen((event) {
      if (event.x.abs() > 20 || event.y.abs() > 20 || event.z.abs() > 20) {
        setState(() => shakeCount++);
        if (shakeCount == 5) recordingService.start();
        // if (shakeCount == 10) locationService.sendLocation();
      }
    });
  }

  @override
  void dispose() {
    recordingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(onChanged: (value) => accused = value),
          TextField(onChanged: (value) => year = value),
          TextField(onChanged: (value) => branch = value),
          TextField(onChanged: (value) => description = value),
          ElevatedButton(
            onPressed: () async {
              await recordingService.stop();
              ReportModel report = ReportModel(accused, year, branch, description, recordingService.audioPath);
              await FirebaseFirestore.instance.collection('reports').add(report.toJson());
            },
            child: Text('রিপোর্ট জমা দিন'),
          ),
        ],
      ),
    );
  }
}