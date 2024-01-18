import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/models/app_models/month_bills_summary_model.dart';

final toBillSummaryProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

final billSummarymonthlyBillSummaryProvider =
    Provider((ref) => BillSummarymonthlyBillSummaryService());

class BillSummarymonthlyBillSummaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MonthlyBillSummaryModel?> billSummarymonthlyBillSummaryFields({
    required String userID,
    required String monthlyBillSummaryID,
    required String monthlyReportID,
    String? newTitle,
    String? newDescription,
    String? newAmount,
    String? newDate,

    // Add other fields here as needed
  }) async {
    final monthlyBillSummaryRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('monthlyReports')
        .doc(monthlyReportID)
        .collection('monthlySummary')
        .doc(monthlyBillSummaryID);

    final Map<String, dynamic> billSummarydFields = {};

    if (newTitle != null) {
      billSummarydFields['monthlyModelTitle'] = newTitle;
    }

    if (newDescription != null) {
      billSummarydFields['description'] = newDescription;
    }

    if (newAmount != null) {
      billSummarydFields['amount'] = newAmount;
    }

    if (newDate != null) {
      billSummarydFields['datemonthlyModel'] = newDate;
    }

    await monthlyBillSummaryRef.update(billSummarydFields);
    final DocumentSnapshot billSummarydDoc = await monthlyBillSummaryRef.get();
    final billSummarydmonthlyBillSummaryData =
        billSummarydDoc.data() as Map<String, dynamic>;
    final billSummarydmonthlyBillSummary =
        MonthlyBillSummaryModel.fromJson(billSummarydmonthlyBillSummaryData);

    return billSummarydmonthlyBillSummary;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
