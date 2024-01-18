import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/goal_model.dart';

class GoalListNotifier extends StateNotifier<List<GoalModel>> {
  GoalListNotifier() : super([]);

  void updateGoals(List<GoalModel> goals) async {
    state = goals;
  }

  void removeGoal(GoalModel goal) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != goal.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Goals')
        .doc(goal.docID)
        .delete();
  }
}

//services

final goalListProvider =
    StateNotifierProvider<GoalListNotifier, List<GoalModel>>(
        (ref) => GoalListNotifier());

final goalProvider = StateProvider<GoalService>((ref) {
  return GoalService();
});

var goalUpdateStateProvider = StateProvider<GoalModel>((ref) {
  return GoalModel(
      goalTitle: '',
      creationDate: '',
      amount: '',
      type: '',
      account: '',
      color: '',
      completionDate: '');
});

class GoalService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewGoal(
      WidgetRef ref, GoalModel model, String userID) async {
    final addedGoalReference =
        await users.doc(userID).collection('Goals').add(model.toJson());

    final goalIDMake = addedGoalReference.id;
    final modelOfGoal = GoalModel(
        docID: goalIDMake,
        goalTitle: model.goalTitle,
        creationDate: model.creationDate,
        amount: model.amount,
        type: model.type,
        account: model.account,
        color: model.color,
        completionDate: model.completionDate);

    ref.read(goalProvider).updateGoal(ref, modelOfGoal);

    return addedGoalReference;
  }

  // UPDATE

  void updateGoalsList(WidgetRef ref, GoalModel updatedGoal) {
    final goalsToUpdate = ref.read(goalListProvider);
    final updatedgoals = <GoalModel>[];

    for (var goal in goalsToUpdate) {
      if (goal.docID == updatedGoal.docID) {
        updatedgoals.add(updatedGoal);
      } else {
        updatedgoals.add(goal);
      }
    }

    ref
        .read(goalListProvider.notifier)
        .updateGoals([...ref.read(goalListProvider)]);
  }

  Future<void> updateGoal(
    WidgetRef ref,
    GoalModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final goalReference =
          users.doc(userID).collection('Goals').doc(model.docID);

      await goalReference.update(model.toJson());

      ref.read(goalUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  void updateDonegoal(String userID, String goalID, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('Goals')
        .doc(goalID)
        .update({'isDone': valueUpdate});
  }

  Future<DocumentReference<Object?>?> addGoal(
      WidgetRef ref, GoalModel model, String userID, GoalModel goal) async {
    DocumentReference addedGoalForGoal =
        await users.doc(userID).collection('Goals').add(goal.toJson());

    goal.docID = addedGoalForGoal.id;
    return addedGoalForGoal;
  }
}

class Goals {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<GoalModel> addNewGoal(
    WidgetRef ref,
    String docID,
    GoalModel model,
  ) async {
    final goal = GoalModel(
      docID: docID,
      goalTitle: model.goalTitle,
      creationDate: model.creationDate,
      amount: model.amount,
      type: model.type,
      account: model.account,
      color: model.color,
      completionDate: model.completionDate,
    );

    await Goals().addGoal(
      ref,
      docID,
      goal,
    );

    return goal;
  }

  Future<DocumentReference<Object?>> addGoal(
    WidgetRef ref,
    String ruleID,
    GoalModel goal,
  ) async {
    final addedGoalReference =
        await users.doc(userID).collection('Goals').add(goal.toJson());

    final goalIDMake = addedGoalReference.id;

    ref.read(goalProvider).updateGoal(
        ref,
        GoalModel(
          docID: goalIDMake,
          goalTitle: goal.goalTitle,
          creationDate: goal.creationDate,
          amount: goal.amount,
          type: goal.type,
          account: goal.account,
          color: goal.color,
          completionDate: goal.completionDate,
        ));

    return addedGoalReference;
  }

  Future<void> updateGoals(
    WidgetRef ref,
    GoalModel model,
  ) async {
    try {
      final goalReference =
          users.doc(userID).collection('Goals').doc(model.docID);

      await goalReference.update(model.toJson());

      ref.read(goalUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  Future<void> deleteRule(String userID, String ruleID) async {
    QuerySnapshot goalCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Goals')
        .get();

    for (var goalDoc in goalCollection.docs) {
      await goalDoc.reference.delete();
    }
  }
}

final fetchGoals = StreamProvider.autoDispose<List<GoalModel>>((ref) async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final goalCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Goals');

  final goalsSnapshot = await goalCollection.get();
  var goals = <GoalModel>[];
  goals.addAll(goalsSnapshot.docs.map((goalDoc) {
    final goalData = goalDoc.data();
    return GoalModel(
      docID: goalDoc.id,
      goalTitle: goalData['goalTitle'] ?? '',
      creationDate: goalData['creationDate'] ?? '',
      amount: goalData['amount'] ?? '',
      type: goalData['type'] ?? '',
      account: goalData['account'] ?? '',
      color: goalData['color'] ?? '',
      completionDate: goalData['completionDate'] ?? '',
    );
  }));
  ref.read(goalListProvider.notifier).updateGoals(goals);
});
