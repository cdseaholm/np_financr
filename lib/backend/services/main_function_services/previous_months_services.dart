import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/updater_model.dart';

class PreviousUpdaterNotifier extends StateNotifier<List<UpdaterModel>> {
  PreviousUpdaterNotifier() : super([]);

  void updatePreviousUpdates(List<UpdaterModel> previousUpdates) async {
    state = previousUpdates;
  }

  void removePreviousUpdates(UpdaterModel previousUpdates) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state
        .where((item) => item.updaterID != previousUpdates.updaterID)
        .toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Monthly Updates')
        .doc(previousUpdates.updaterID)
        .delete();
  }
}

//services

final previousUpdatesListProvider =
    StateNotifierProvider<PreviousUpdaterNotifier, List<UpdaterModel>>(
        (ref) => PreviousUpdaterNotifier());

final previousUpdatesProvider = StateProvider<PreviousUpdatesService>((ref) {
  return PreviousUpdatesService();
});

var previousUpdateStateProvider = StateProvider<UpdaterModel>((ref) {
  return UpdaterModel(
      updaterID: '', updaterTitle: '', updatedDate: '', updaterAmount: '');
});

class PreviousUpdatesService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewPreviousUpdates(
    WidgetRef ref,
    UpdaterModel model,
    String userID,
  ) async {
    final addedPreviousUpdatesReference = await users
        .doc(userID)
        .collection('Monthly Reports')
        .add(model.toJson());

    final previousUpdatesIDMake = addedPreviousUpdatesReference.id;
    final modelOfPreviousUpdates = UpdaterModel(
        updaterID: previousUpdatesIDMake,
        updaterTitle: model.updaterTitle,
        updaterAmount: model.updaterAmount,
        updatedDate: model.updatedDate);

    ref
        .read(previousUpdatesProvider)
        .updatePreviousUpdates(ref, modelOfPreviousUpdates);

    return addedPreviousUpdatesReference;
  }

  // UPDATE

  void updatePreviousUpdatesList(WidgetRef ref, UpdaterModel previousUpdates) {
    final previousUpdatesToUpdate = ref.read(previousUpdatesListProvider);
    final updatedPreviousUpdates = <UpdaterModel>[];

    for (var previousUpdates in previousUpdatesToUpdate) {
      if (previousUpdates.updaterID == previousUpdates.updaterID) {
        updatedPreviousUpdates.add(previousUpdates);
      } else {
        updatedPreviousUpdates.add(previousUpdates);
      }
    }

    ref
        .read(previousUpdatesListProvider.notifier)
        .updatePreviousUpdates([...ref.read(previousUpdatesListProvider)]);
  }

  Future<void> updatePreviousUpdates(
    WidgetRef ref,
    UpdaterModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final previousUpdatesReference =
          users.doc(userID).collection('Monthly Updates').doc(model.updaterID);

      await previousUpdatesReference.update(model.toJson());

      ref.read(previousUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }
}
