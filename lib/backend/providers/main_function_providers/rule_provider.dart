import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/account_model.dart';
import '../../../data/models/app_models/rule_model.dart';
import '../../services/main_function_services/air_services.dart';
import '../../services/main_function_services/rule_service.dart';

final ruleProvider = StateNotifierProvider<RuleListNotifier, List<RuleModel>>(
    (ref) => RuleListNotifier());

class RuleListNotifier extends StateNotifier<List<RuleModel>> {
  RuleListNotifier() : super([]);

  Future<void> updateRules(List<RuleModel> rule) async {
    state = rule;
  }

  Future<void> removeRules(RuleModel rule) async {
    state = state.where((item) => item.ruleID != rule.ruleID).toList();
  }
}

final airProvider = StateProvider<List<AccountModel>>((ref) {
  return [
    AccountModel(
      docID: '',
      accountTitle: '',
      description: '',
      creationDate: '',
      amount: '',
    )
  ];
});

final ruleListProvider =
    StateNotifierProvider<RuleListNotifier, List<RuleModel>>(
        (ref) => RuleListNotifier());

final ruleServiceProvider = StateProvider<RuleService>(
  (ref) {
    return RuleService();
  },
);

final accountsForRulesProvider = StateProvider<AccountsForRules>(
  (ref) {
    return AccountsForRules();
  },
);

final fetchRules = StreamProvider.autoDispose<List<RuleModel>>((ref) {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final ruleCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Rules');

  final Stream<QuerySnapshot> ruleStream = ruleCollection.snapshots();

  return ruleStream.asyncMap((ruleSnapshot) {
    var rules = <RuleModel>[];
    for (final ruleDoc in ruleSnapshot.docs) {
      final ruleData = ruleDoc.data() as Map<String, dynamic>;
      rules.add(RuleModel(
          ruleID: ruleDoc.id,
          ruleTitle: ruleData['ruleTitle'],
          creationDate: ruleData['creationDate']));
    }

    ref.read(ruleListProvider.notifier).updateRules(rules);
    return rules;
  });
});
