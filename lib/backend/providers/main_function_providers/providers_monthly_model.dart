import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/model_monthly_update.dart';
import 'package:np_financr/data/models/app_models/month_bills_summary_model.dart';
import 'package:np_financr/backend/services/main_function_services/monthly_bill_summary_service.dart';
import '../../services/main_function_services/services_monthly_update.dart';

final fetchMonthlyUpdates =
    StreamProvider.autoDispose<List<MonthlyUpdateModel>>(
  (ref) async* {
    final userID = FirebaseAuth.instance.currentUser?.uid;

    final monthlyUpdateCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('monthlyReports');

    final monthlyUpdatesSnapshot = await monthlyUpdateCollection.get();
    var monthlyUpdates = <MonthlyUpdateModel>[];
    monthlyUpdates.addAll(monthlyUpdatesSnapshot.docs.map((monthlyUpdateDoc) {
      final monthlyUpdateData = monthlyUpdateDoc.data();
      return MonthlyUpdateModel(
        docID: monthlyUpdateDoc.id,
        monthlyModelTitle: monthlyUpdateData['monthlyModelTitle'] ?? '',
        notes: monthlyUpdateData['notes'] ?? '',
        datemonthlyModel: monthlyUpdateData['datemonthlyModel'] ?? '',
        amount: monthlyUpdateData['amount'] ?? '',
        creationDate: monthlyUpdateData['creationDate'] ?? '',
      );
    }));
    ref
        .read(monthlyUpdateListProvider.notifier)
        .updatemonthlyUpdates(monthlyUpdates);
    for (var billSummary in monthlyUpdates) {
      var billSummaryList = <MonthlyBillSummaryModel>[];
      // Assuming 'monthlyReports' has a subcollection named 'summary'
      final summaryCollection =
          monthlyUpdateCollection.doc(billSummary.docID).collection('summary');

      final summarySnapshot = await summaryCollection.get();
      billSummaryList.addAll(summarySnapshot.docs.map((summaryDoc) {
        final summaryData = summaryDoc.data();
        return MonthlyBillSummaryModel(
          docID: summaryDoc.id,
          billSummaryPieceTitle: summaryData['billSummaryPieceTitle'] ?? '',
          billSummaryPieceAmount: summaryData['billSummaryPieceAmount'] ?? '',
          creationDate: summaryData['creationDate'] ?? '',
        );
      }));

      ref
          .read(monthlyBillSummaryListProvider.notifier)
          .updatemonthlyBillSummary(billSummaryList);
    }
  },
);

final toUpdateProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

final updatemonthlyUpdateProvider =
    Provider((ref) => UpdatemonthlyUpdateService());

class UpdatemonthlyUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MonthlyUpdateModel?> updatemonthlyUpdateFields({
    required String userID,
    required String monthlyUpdateID,
    String? newTitle,
    String? newNotes,
    String? newAmount,
    String? newDate,
    String? newMonth,

    // Add other fields here as needed
  }) async {
    final monthlyUpdateRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('monthlyReports')
        .doc(monthlyUpdateID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['monthlyModelTitle'] = newTitle;
    }

    if (newNotes != null) {
      updatedFields['notes'] = newNotes;
    }

    if (newAmount != null) {
      updatedFields['amount'] = newAmount;
    }

    if (newDate != null) {
      updatedFields['creationDate'] = newDate;
    }

    if (newMonth != null) {
      updatedFields['datemonthlyModel'] = newMonth;
    }

    await monthlyUpdateRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await monthlyUpdateRef.get();
    final updatedmonthlyUpdateData = updatedDoc.data() as Map<String, dynamic>;
    final updatedmonthlyUpdate =
        MonthlyUpdateModel.fromJson(updatedmonthlyUpdateData);

    return updatedmonthlyUpdate;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
