import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/model_bills.dart';

class FinanceListNotifier extends StateNotifier<List<BillDetailsModel>> {
  FinanceListNotifier() : super([]);

  void updatebillDetails(List<BillDetailsModel> billDetails) async {
    state = billDetails;
  }

  void removebillDetails(BillDetailsModel billDetails) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.billID != billDetails.billID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Bills')
        .doc(billDetails.billID)
        .delete();
  }
}

//services

final billDetailsListProvider =
    StateNotifierProvider<FinanceListNotifier, List<BillDetailsModel>>(
        (ref) => FinanceListNotifier());

final billDetailsProvider = StateProvider<BillDetailsService>((ref) {
  return BillDetailsService();
});

var billDetailsListStateProvider = StateProvider<List<BillDetailsModel>>((ref) {
  return [];
});

var billUpdateStateProvider = StateProvider<BillDetailsModel>((ref) {
  return BillDetailsModel(
      billTitle: '',
      billPaid: false,
      billWaived: false,
      creationDate: '',
      amount: '');
});

class BillDetailsService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewbillDetails(
    WidgetRef ref,
    BillDetailsModel model,
    String userID,
  ) async {
    final addedbillDetailsReference =
        await users.doc(userID).collection('Bills').add(model.toJson());

    final billDetailsIDMake = addedbillDetailsReference.id;
    final modelOfBillDetails = BillDetailsModel(
        billID: billDetailsIDMake,
        billTitle: model.billTitle,
        billPaid: model.billPaid,
        billWaived: model.billWaived,
        creationDate: model.creationDate,
        amount: model.amount);

    ref.read(billDetailsProvider).updatebillDetails(ref, modelOfBillDetails);

    return addedbillDetailsReference;
  }

  // UPDATE

  void updatebillDetailsList(WidgetRef ref, BillDetailsModel billDetails) {
    final billDetailsToUpdate = ref.read(billDetailsListProvider);
    final updatedbillDetails = <BillDetailsModel>[];

    for (var billDetails in billDetailsToUpdate) {
      if (billDetails.billID == billDetails.billID) {
        updatedbillDetails.add(billDetails);
      } else {
        updatedbillDetails.add(billDetails);
      }
    }

    ref
        .read(billDetailsListProvider.notifier)
        .updatebillDetails([...ref.read(billDetailsListProvider)]);
  }

  Future<void> updatebillDetails(
    WidgetRef ref,
    BillDetailsModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final billDetailsReference =
          users.doc(userID).collection('Bills').doc(model.billID);

      await billDetailsReference.update(model.toJson());

      ref.read(billUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }
}
