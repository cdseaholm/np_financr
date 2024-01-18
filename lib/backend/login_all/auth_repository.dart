import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../frontend/view/logged_in_homepage.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.idTokenChanges();
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class GoogleAuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoggedInHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'account-exists-with-different-credential') {
          showErrorMessage(
              context, 'Account Exists with different credentials');
        } else if (e.code == 'invalid-credential') {
          showErrorMessage(context, 'Invalid Credential');
        } else if (e.code == 'user-disabled') {
          showErrorMessage(context, 'User disabled');
        } else if (e.code == 'user-not-found') {
          showErrorMessage(context, 'User not found');
        } else if (e.code == 'wrong-password') {
          showErrorMessage(context, 'Incorrect Password');
        } else if (e.code == 'invalid-verification-code') {
          showErrorMessage(context, 'Invalid Verification Code');
        } else if (e.code == 'invalid-verification-id') {
          showErrorMessage(context, 'Invalid ID');
        } else {
          showErrorMessage(context, 'Unknown error occurred');
        }
      }
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: HexColor("#456B4C"),
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
