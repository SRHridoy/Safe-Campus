import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String accused, year, branch, description;
  final String? audioPath;

  ReportModel(this.accused, this.year, this.branch, this.description, this.audioPath);

  Map<String, dynamic> toJson() => {
    'accused': accused,
    'year': year,
    'branch': branch,
    'description': description,
    'audio': audioPath,
    'timestamp': FieldValue.serverTimestamp(),
  };
}