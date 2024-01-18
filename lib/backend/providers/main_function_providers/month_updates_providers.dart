import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/services/main_function_services/previous_months_services.dart';

import '../../../data/models/app_models/updater_model.dart';

final fetchMonthlyUpdates =
    StreamProvider.autoDispose<List<UpdaterModel>>((ref) async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final monthlyUpdateCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Monthly Updates');

  final previousUpdatesSnapshot = await monthlyUpdateCollection.get();
  var previousUpdates = <UpdaterModel>[];
  previousUpdates.addAll(previousUpdatesSnapshot.docs.map((previousUpdatesDoc) {
    final previousUpdatesData = previousUpdatesDoc.data();
    return UpdaterModel(
      updaterID: previousUpdatesDoc.id,
      updaterTitle: previousUpdatesData['updaterTitle'] ?? '',
      updaterAmount: previousUpdatesData['updaterAmount'] ?? '',
      updatedDate: previousUpdatesData['updatedDate'] ?? '',
    );
  }));
  ref
      .read(previousUpdatesListProvider.notifier)
      .updatePreviousUpdates(previousUpdates);

  var instances = <UpdaterModel>[];

  for (final specificpreviousUpdatesDoc in previousUpdatesSnapshot.docs) {
    final previousUpdatesInstancesCollection =
        specificpreviousUpdatesDoc.reference.collection('Tasks');
    final previousUpdatesInstanceSnapshot =
        await previousUpdatesInstancesCollection.get();

    instances.addAll(
      previousUpdatesInstanceSnapshot.docs.map((instanceDoc) {
        final previousUpdatesData = instanceDoc.data();
        return UpdaterModel(
          updaterID: instanceDoc.id,
          updaterTitle: previousUpdatesData['updaterTitle'] ?? '',
          updaterAmount: previousUpdatesData['updaterAmount'] ?? '',
          updatedDate: previousUpdatesData['updatedDate'] ?? '',
        );
      }),
    );
  }

  yield instances;

  ref
      .read(previousUpdatesListProvider.notifier)
      .updatePreviousUpdates(instances);
});

final updatepreviousUpdatesProvider =
    Provider((ref) => UpdatepreviousUpdatesService());

class UpdatepreviousUpdatesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UpdaterModel?> updatepreviousUpdatesFields({
    required String userID,
    required String previousUpdatesID,
    String? newTitle,
    String? newDescription,
    String? newAmount,
    String? newDate,

    // Add other fields here as needed
  }) async {
    final previousUpdatesRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Monthly Updates')
        .doc(previousUpdatesID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['previousUpdatesTitle'] = newTitle;
    }

    if (newDescription != null) {
      updatedFields['previousUpdatesPaid'] = newDescription;
    }

    if (newAmount != null) {
      updatedFields['previousUpdatesWaived'] = newAmount;
    }

    if (newDate != null) {
      updatedFields['creationDate'] = newDate;
    }

    await previousUpdatesRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await previousUpdatesRef.get();
    final updatedpreviousUpdatesData =
        updatedDoc.data() as Map<String, dynamic>;
    final updatedpreviousUpdates =
        UpdaterModel.fromJson(updatedpreviousUpdatesData);

    return updatedpreviousUpdates;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
