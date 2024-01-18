import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/month_bills_summary_model.dart';

class MonthlyBillSummaryNotifier
    extends StateNotifier<List<MonthlyBillSummaryModel>> {
  MonthlyBillSummaryNotifier() : super([]);

  void updatemonthlyBillSummary(
      List<MonthlyBillSummaryModel> monthlyBillSummary) async {
    state = monthlyBillSummary;
  }

  void removemonthlyBillSummary(MonthlyBillSummaryModel monthlyBillSummary) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state =
        state.where((item) => item.docID != monthlyBillSummary.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('monthlyBillSummary')
        .doc(monthlyBillSummary.docID)
        .delete();
  }
}

//services

final monthlyBillSummaryListProvider = StateNotifierProvider<
    MonthlyBillSummaryNotifier,
    List<MonthlyBillSummaryModel>>((ref) => MonthlyBillSummaryNotifier());

final monthlyBillSummaryProvider =
    StateProvider<MonthlyBillSummaryService>((ref) {
  return MonthlyBillSummaryService();
});

var monthlyBillSummaryUpdateStateProvider =
    StateProvider<MonthlyBillSummaryModel>((ref) {
  return MonthlyBillSummaryModel(
      billSummaryPieceTitle: '', billSummaryPieceAmount: '', creationDate: '');
});

class MonthlyBillSummaryService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewmonthlyBillSummary(
      WidgetRef ref,
      MonthlyBillSummaryModel model,
      String userID,
      String monthlyReportID) async {
    final addedmonthlyBillSummaryReference = await users
        .doc(userID)
        .collection('monthlyReports')
        .doc(monthlyReportID)
        .collection('monthlyBillSummary')
        .add(model.toJson());

    final monthlyBillSummaryIDMake = addedmonthlyBillSummaryReference.id;
    final modelOfmonthlyBillSummary = MonthlyBillSummaryModel(
        docID: monthlyBillSummaryIDMake,
        billSummaryPieceTitle: model.billSummaryPieceTitle,
        billSummaryPieceAmount: model.billSummaryPieceAmount,
        creationDate: model.creationDate);

    ref
        .read(monthlyBillSummaryProvider)
        .updatemonthlyBillSummary(ref, modelOfmonthlyBillSummary);

    return addedmonthlyBillSummaryReference;
  }

  // UPDATE

  void updatemonthlyBillSummaryList(
      WidgetRef ref, MonthlyBillSummaryModel monthlyBillSummary) {
    final monthlyBillSummaryToUpdate = ref.read(monthlyBillSummaryListProvider);
    final updatedmonthlyBillSummary = <MonthlyBillSummaryModel>[];

    for (var monthlyBillSummary in monthlyBillSummaryToUpdate) {
      if (monthlyBillSummary.docID == monthlyBillSummary.docID) {
        updatedmonthlyBillSummary.add(monthlyBillSummary);
      } else {
        updatedmonthlyBillSummary.add(monthlyBillSummary);
      }
    }

    ref.read(monthlyBillSummaryListProvider.notifier).updatemonthlyBillSummary(
        [...ref.read(monthlyBillSummaryListProvider)]);
  }

  Future<void> updatemonthlyBillSummary(
    WidgetRef ref,
    MonthlyBillSummaryModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final monthlyBillSummaryReference =
          users.doc(userID).collection('monthlyBillSummary').doc(model.docID);

      await monthlyBillSummaryReference.update(model.toJson());

      ref.read(monthlyBillSummaryUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }
}
