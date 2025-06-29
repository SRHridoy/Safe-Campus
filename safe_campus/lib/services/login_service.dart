import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String studentId,
    required String name,
    required String department,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore
          .collection('user_infos')
          .doc(userCredential.user?.uid)
          .set({
        'studentId': studentId.trim(),
        'name': name.trim(),
        'department': department.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null; // Sign up successful
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    // Admin login check
    if (email.trim() == 'admin@pb.com' && password.trim() == 'adminPB') {
      return 'admin'; // Indicate admin login
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('user_infos')
          .doc(userCredential.user?.uid)
          .get();
      if (userDoc.exists) {
        return 'user'; // Login successful, user role
      } else {
        return 'No user data found.';
      }
    } catch (e) {
      return e.toString();
    }
  }
}