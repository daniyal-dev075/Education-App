import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/features/auth_and_profile/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/routes/route_name.dart';
import '../../../../../utils/utils.dart';
import '../../splash/view_model/navigation_view_model.dart';

class AuthViewModel extends ChangeNotifier {


  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userVM = Provider.of<UserViewModel>(context, listen: false);
      await userVM.fetchUserData();

      Provider.of<NavigationViewModel>(context, listen: false).resetIndex();
      Utils().toastMessage('Logged In Successfully');
      Navigator.pushReplacementNamed(
        context,
        RouteName.mainWrapper,
      );
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message.toString());
    } finally {
      setLoading(false);
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
    required bool isOnline,
    required String phoneNumber,
    required BuildContext context,
    File? profileImage,
  }) async {
    setLoading(true);
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = '';
      if (profileImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_pics')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(profileImage);
        imageUrl = await storageRef.getDownloadURL();
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'profilePic': imageUrl,
        'phoneNumber': phoneNumber,
        'isOnline': isOnline,
      });

      Utils().toastMessage('Account Created Successfully');
      Navigator.pushNamed(context, RouteName.loginView);
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message.toString());
    } finally {
      setLoading(false);
    }
  }

  void resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils().toastMessage(
          'We have sent you an email to reset your password. Please check your inbox.');
      Navigator.pop(context); // Close bottom sheet
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message.toString());
    } finally {
      setLoading(false);
    }
  }
  void logout(BuildContext context) async {
    setLoading(true);
    try {
      await _auth.signOut();
      Utils().toastMessage('Logged Out');
      Navigator.pushNamed(context, RouteName.loginView);
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
  Future<void> updateUserData({
    required String uid,
    String? name,
    String? email,
    String? phoneNumber,
    File? profileImage, // optional for updating image
    required BuildContext context,
  }) async {
    setLoading(true);
    try {
      final Map<String, dynamic> updatedData = {};

      if (name != null) updatedData['name'] = name;
      if (email != null) updatedData['email'] = email;
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;

      // Upload new profile image if provided
      if (profileImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_pics')
            .child('$uid.jpg');

        await storageRef.putFile(profileImage);
        final imageUrl = await storageRef.getDownloadURL();
        updatedData['profilePic'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedData);

      Utils().toastMessage("Profile updated successfully.\n Restart the app to see changes!");
    } on FirebaseException catch (e) {
      Utils().toastMessage(e.message.toString());
    } finally {
      setLoading(false);
    }
  }


}

