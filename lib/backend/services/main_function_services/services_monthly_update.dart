import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/model_monthly_update.dart';

class MonthlyReportsNotifier extends StateNotifier<List<MonthlyUpdateModel>> {
  MonthlyReportsNotifier() : super([]);

  void updatemonthlyUpdates(List<MonthlyUpdateModel> monthlyUpdates) async {
    state = monthlyUpdates;
  }

  void removemonthlyUpdate(MonthlyUpdateModel monthlyUpdate) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != monthlyUpdate.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('monthlyReports')
        .doc(monthlyUpdate.docID)
        .delete();
  }
}

//services

final monthlyUpdateListProvider =
    StateNotifierProvider<MonthlyReportsNotifier, List<MonthlyUpdateModel>>(
        (ref) => MonthlyReportsNotifier());

final monthlyUpdateProvider = StateProvider<MonthlyUpdateService>((ref) {
  return MonthlyUpdateService();
});

var monthlyUpdateUpdateStateProvider = StateProvider<MonthlyUpdateModel>((ref) {
  return MonthlyUpdateModel(
    monthlyModelTitle: '',
    notes: '',
    datemonthlyModel: '',
    amount: '',
    creationDate: '',
  );
});

class MonthlyUpdateService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewmonthlyUpdate(
      WidgetRef ref, MonthlyUpdateModel model, String userID) async {
    final addedmonthlyUpdateReference = await users
        .doc(userID)
        .collection('monthlyReports')
        .add(model.toJson());

    final monthlyUpdateIDMake = addedmonthlyUpdateReference.id;
    final modelOfMonthlyUpdate = MonthlyUpdateModel(
        docID: monthlyUpdateIDMake,
        monthlyModelTitle: model.monthlyModelTitle,
        notes: model.notes,
        datemonthlyModel: model.datemonthlyModel,
        amount: model.amount,
        creationDate: model.creationDate);

    ref
        .read(monthlyUpdateProvider)
        .updatemonthlyUpdate(ref, modelOfMonthlyUpdate);

    return addedmonthlyUpdateReference;
  }

  // UPDATE

  void updatemonthlyUpdatesList(
      WidgetRef ref, MonthlyUpdateModel updatedmonthlyUpdate) {
    final monthlyUpdatesToUpdate = ref.read(monthlyUpdateListProvider);
    final updatedmonthlyUpdates = <MonthlyUpdateModel>[];

    for (var monthlyUpdate in monthlyUpdatesToUpdate) {
      if (monthlyUpdate.docID == updatedmonthlyUpdate.docID) {
        updatedmonthlyUpdates.add(updatedmonthlyUpdate);
      } else {
        updatedmonthlyUpdates.add(monthlyUpdate);
      }
    }

    ref
        .read(monthlyUpdateListProvider.notifier)
        .updatemonthlyUpdates([...ref.read(monthlyUpdateListProvider)]);
  }

  Future<void> updatemonthlyUpdate(
    WidgetRef ref,
    MonthlyUpdateModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final monthlyUpdateReference =
          users.doc(userID).collection('monthlyReports').doc(model.docID);

      await monthlyUpdateReference.update(model.toJson());

      ref.read(monthlyUpdateUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }
}
