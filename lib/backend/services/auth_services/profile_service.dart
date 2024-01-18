import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // READ

  // UPDATE
  Future<void> updateDisplayName(
      String userID, String updatedDisplayName) async {
    await users.doc(userID).update({'display name': updatedDisplayName});
  }

  Future<void> updateFilter(WidgetRef ref, String filterView) async {
    final user = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .update({'filterView': filterView});
  }

  Future<void> updateCustomUsername(
      String userID, String updatedCustomUsername) async {
    await users.doc(userID).update({'custom username': updatedCustomUsername});

    final userSnapshot = await users.doc(userID).get();
    final displayName = userSnapshot.get('display name') as String?;
    if (displayName == null || displayName == updatedCustomUsername) {
      return;
    }
    await users.doc(userID).update({'display name': updatedCustomUsername});
  }
  //DELETE
}
