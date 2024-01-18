import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/model_bills.dart';

import '../../../data/models/app_models/model_bills_instances.dart';

class FinanceListNotifier extends StateNotifier<List<BillInstancesModel>> {
  FinanceListNotifier() : super([]);

  void updatebillInstances(List<BillInstancesModel> billInstances) async {
    state = billInstances;
  }

  void removebillInstances(BillInstancesModel billInstances) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state
        .where((item) => item.billInstanceID != billInstances.billInstanceID)
        .toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Bills')
        .doc(billInstances.billInstanceID)
        .delete();
  }
}

//services

final billInstancesListProvider =
    StateNotifierProvider<FinanceListNotifier, List<BillInstancesModel>>(
        (ref) => FinanceListNotifier());

final billInstancesProvider = StateProvider<BillInstancesService>((ref) {
  return BillInstancesService();
});

var billInstancesUpdateStateProvider = StateProvider<BillInstancesModel>((ref) {
  return BillInstancesModel(
      monthlyUpdateID: '', instanceAmount: '', instanceDate: '');
});

class BillInstancesService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewbillInstances(
      WidgetRef ref,
      BillInstancesModel model,
      String userID,
      BillDetailsModel billDetails) async {
    final addedbillInstancesReference = await users
        .doc(userID)
        .collection('Bills')
        .doc(billDetails.billID)
        .collection('Bills')
        .add(model.toJson());

    final billInstancesIDMake = addedbillInstancesReference.id;
    final modelOfBillInstances = BillInstancesModel(
        billInstanceID: billInstancesIDMake,
        monthlyUpdateID: model.monthlyUpdateID,
        instanceAmount: model.instanceAmount,
        instanceDate: model.instanceDate);

    ref
        .read(billInstancesProvider)
        .updatebillInstances(ref, billDetails, modelOfBillInstances);

    return addedbillInstancesReference;
  }

  // UPDATE

  void updatebillInstancesList(
      WidgetRef ref, BillInstancesModel billInstances) {
    final billInstancesToUpdate = ref.read(billInstancesListProvider);
    final updatedbillInstances = <BillInstancesModel>[];

    for (var billInstances in billInstancesToUpdate) {
      if (billInstances.billInstanceID == billInstances.billInstanceID) {
        updatedbillInstances.add(billInstances);
      } else {
        updatedbillInstances.add(billInstances);
      }
    }

    ref
        .read(billInstancesListProvider.notifier)
        .updatebillInstances([...ref.read(billInstancesListProvider)]);
  }

  Future<void> updatebillInstances(
    WidgetRef ref,
    BillDetailsModel details,
    BillInstancesModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final billInstancesReference = users
          .doc(userID)
          .collection('Bills')
          .doc(details.billID)
          .collection('Instances')
          .doc(model.billInstanceID);

      await billInstancesReference.update(model.toJson());

      ref.read(billInstancesUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }
}
