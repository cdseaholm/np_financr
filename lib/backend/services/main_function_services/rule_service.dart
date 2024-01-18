import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/rule_model.dart';
import '../../providers/main_function_providers/rule_provider.dart';
import '../../providers/main_function_providers/selected_rule_providers.dart';

class RuleService {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<DocumentReference> addNewRule(WidgetRef ref, RuleModel model) async {
    final addedRuleReference =
        await users.doc(userID).collection('Rules').add(model.toJson());

    final ruleIDMake = addedRuleReference.id;

    ref.read(ruleServiceProvider).updateRule(
          ref,
          RuleModel(
            ruleID: ruleIDMake,
            ruleTitle: model.ruleTitle,
            creationDate: model.creationDate,
          ),
        );

    return addedRuleReference;
  }

  Future<void> updateRule(
    WidgetRef ref,
    RuleModel model,
  ) async {
    try {
      final ruleReference =
          users.doc(userID).collection('Rules').doc(model.ruleID);

      await ruleReference.update(model.toJson());

      ref.read(selectedRuleProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  Future<void> deleteRule(String userID, String ruleID) async {
    try {
      QuerySnapshot accountsInRulesCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('Rules')
          .doc(ruleID)
          .collection('Accounts')
          .get();

      for (var accountDoc in accountsInRulesCollection.docs) {
        await accountDoc.reference.delete();
      }
    } finally {
      CollectionReference rulesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('Rules');

      await rulesCollection.doc(ruleID).delete();
    }
  }

  Future<bool> checkRuleExists(String ruleName) async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final ruleSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Rules')
        .where('ruleName', isEqualTo: ruleName)
        .get();

    return ruleSnapshot.docs.isNotEmpty;
  }

  Future<String> getNoRuleID(String ruleName) async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final QuerySnapshot ruleSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Rules')
        .where('ruleName', isEqualTo: ruleName)
        .get();

    return ruleSnapshot.docs.first.id;
  }

  Future<void> ruleEmptyAlertMethod(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Rule Name cannot be empty',
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                )
              ]);
        });
  }

  Future<void> ruleNameInUseMessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Rule Name is already in use',
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                )
              ]);
        });
  }
}
