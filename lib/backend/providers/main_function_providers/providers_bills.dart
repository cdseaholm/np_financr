import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/model_bills_instances.dart';
import 'package:np_financr/backend/services/main_function_services/services_bills_instances.dart';
import 'package:np_financr/backend/services/main_function_services/services_bills.dart';

import '../../../data/models/app_models/model_bills.dart';

final fetchBillDetails =
    StreamProvider.autoDispose<List<BillInstancesModel>>((ref) async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final monthlyUpdateCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Bills');

  final billDetailsSnapshot = await monthlyUpdateCollection.get();
  var billDetails = <BillDetailsModel>[];
  billDetails.addAll(billDetailsSnapshot.docs.map((billDetailsDoc) {
    final billDetailsData = billDetailsDoc.data();
    return BillDetailsModel(
        billID: billDetailsDoc.id,
        billTitle: billDetailsData['billTitle'] ?? '',
        billPaid: billDetailsData['billPaid'] ?? false,
        billWaived: billDetailsData['billWaived'] ?? false,
        creationDate: billDetailsData['creationDate'] ?? '',
        amount: billDetailsData['amount'] ?? '');
  }));
  ref.read(billDetailsListProvider.notifier).updatebillDetails(billDetails);

  var instances = <BillInstancesModel>[];

  for (final specificBillDetailsDoc in billDetailsSnapshot.docs) {
    final billInstancesCollection =
        specificBillDetailsDoc.reference.collection('Tasks');
    final billInstanceSnapshot = await billInstancesCollection.get();

    instances.addAll(
      billInstanceSnapshot.docs.map((instanceDoc) {
        final billData = instanceDoc.data();
        return BillInstancesModel(
          billInstanceID: instanceDoc.id,
          monthlyUpdateID: billData['monthlyUpdateID'] ?? '',
          instanceAmount: billData['instanceAmount'] ?? '',
          instanceDate: billData['instanceDate'] ?? '',
        );
      }),
    );
  }

  yield instances;

  ref.read(billInstancesListProvider.notifier).updatebillInstances(instances);
});

final updatebillDetailsProvider = Provider((ref) => UpdatebillDetailsService());

class UpdatebillDetailsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BillDetailsModel?> updatebillDetailsFields({
    required String userID,
    required String billID,
    String? newTitle,
    String? newDescription,
    String? newAmount,
    String? newDate,

    // Add other fields here as needed
  }) async {
    final billDetailsRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Bills')
        .doc(billID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['billTitle'] = newTitle;
    }

    if (newDescription != null) {
      updatedFields['billPaid'] = newDescription;
    }

    if (newAmount != null) {
      updatedFields['billWaived'] = newAmount;
    }

    if (newDate != null) {
      updatedFields['creationDate'] = newDate;
    }

    await billDetailsRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await billDetailsRef.get();
    final updatedbillDetailsData = updatedDoc.data() as Map<String, dynamic>;
    final updatedbillDetails =
        BillDetailsModel.fromJson(updatedbillDetailsData);

    return updatedbillDetails;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
