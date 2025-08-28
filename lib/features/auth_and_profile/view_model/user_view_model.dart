import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserViewModel extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  UserViewModel() {
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          _userData = doc.data();
        } else {
          debugPrint("⚠️ No Firestore document found for UID: ${user.uid}");
        }
      } else {
        debugPrint("⚠️ No authenticated user found.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
