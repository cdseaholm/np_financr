import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/model_bills_instances.dart';

final updatebillInstanceProvider =
    Provider((ref) => UpdatebillInstanceService());

class UpdatebillInstanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BillInstancesModel?> updatebillInstanceFields({
    required String userID,
    required String billInstanceID,
    required String billID,
    String? newInstanceAmount,
    String? newInstanceDate,

    // Add other fields here as needed
  }) async {
    final billInstanceRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Bills')
        .doc(billID)
        .collection('Instances')
        .doc(billInstanceID);

    final Map<String, dynamic> updatedFields = {};

    if (newInstanceAmount != null) {
      updatedFields['instanceAmount'] = newInstanceAmount;
    }

    if (newInstanceDate != null) {
      updatedFields['instanceDate'] = newInstanceDate;
    }

    await billInstanceRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await billInstanceRef.get();
    final updatedbillInstanceData = updatedDoc.data() as Map<String, dynamic>;
    final updatedbillInstance =
        BillInstancesModel.fromJson(updatedbillInstanceData);

    return updatedbillInstance;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
