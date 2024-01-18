import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../frontend/view/logged_out_homepage.dart';

class AuthSignOut {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final googleSignIn = GoogleSignIn();
      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out from Google: $e');
    }

    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out from Firebase: $e');
    }

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoggedOutHomePage()),
    );
  }
}
