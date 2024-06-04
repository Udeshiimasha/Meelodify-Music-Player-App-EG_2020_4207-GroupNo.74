import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _profileName = 'John Doe';
  String _profilePhone = '+1234567890';
  String _profileEmail = '';
  String? _profileImagePath;

  String get profileName => _profileName;
  String get profilePhone => _profilePhone;
  String get profileEmail => _profileEmail;
  String? get profileImagePath => _profileImagePath;

  ProfileController() {
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _profileEmail = user.email ?? '';
      DocumentSnapshot userProfile =
          await _firestore.collection('users').doc(user.uid).get();
      if (userProfile.exists) {
        _profileName = userProfile['name'];
        _profilePhone = userProfile['phone'];
        _profileImagePath = userProfile['profileImagePath'];
        notifyListeners();
      }
    }
  }

  void _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': _profileName,
        'phone': _profilePhone,
        'email': _profileEmail,
        'profileImagePath': _profileImagePath,
      });
    }
  }

  void setProfileName(String name) {
    _profileName = name;
    _updateUserProfile();
    notifyListeners();
  }

  void setProfilePhone(String phone) {
    _profilePhone = phone;
    _updateUserProfile();
    notifyListeners();
  }

  void setProfileImagePath(String? path) {
    _profileImagePath = path;
    _updateUserProfile();
    notifyListeners();
  }

  void logout() {
    _auth.signOut();
    notifyListeners();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword);
      }).catchError((error) {
        throw Exception('Failed to reauthenticate: $error');
      });
    } else {
      throw Exception('No user is signed in');
    }
  }
}
