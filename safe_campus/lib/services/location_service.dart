// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LocationService {
//   Future<void> sendLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     await FirebaseFirestore.instance.collection('admin_locations').add({
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
// }