// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class AIRModel {
  late String docID;
  late String ruleID;
  late String accountTitle;
  final String creationDate;
  late String amountType;
  late String accountPortion;
  late String currentAccountAmount;
  late String thisPaycheckCut;

  AIRModel(
      {String? docID,
      required this.ruleID,
      required this.accountTitle,
      required this.creationDate,
      required this.amountType,
      required this.accountPortion,
      required this.currentAccountAmount,
      required this.thisPaycheckCut})
      : docID = docID ?? '';

  AIRModel copyWith(
      {String? docID,
      String? ruleID,
      String? accountTitle,
      String? creationDate,
      String? amountType,
      String? accountPortion,
      String? currentAccountAmount,
      String? thisPaycheckCut}) {
    return AIRModel(
        docID: docID ?? this.docID,
        ruleID: ruleID ?? this.ruleID,
        accountTitle: accountTitle ?? this.accountTitle,
        creationDate: creationDate ?? this.creationDate,
        amountType: amountType ?? '',
        accountPortion: accountPortion ?? this.accountPortion,
        currentAccountAmount: currentAccountAmount ?? this.currentAccountAmount,
        thisPaycheckCut: thisPaycheckCut ?? this.thisPaycheckCut);
  }

  AIRModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        ruleID = doc['ruleID'],
        accountTitle = doc['accountTitle'],
        creationDate = doc['creationDate'],
        amountType = doc['amountType'],
        accountPortion = doc['accountPortion'],
        currentAccountAmount = doc['currentAccountAmount'],
        thisPaycheckCut = doc['thisPaycheckCut'];

  AIRModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        ruleID = json['ruleID'] as String,
        accountTitle = json['accountTitle'] as String,
        creationDate = json['creationDate'] as String,
        amountType = json['amountType'] as String,
        accountPortion = json['accountPortion'] as String,
        currentAccountAmount = json['currentAccountAmount'] as String,
        thisPaycheckCut = json['thisPaycheckCut'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'ruleID': ruleID,
        'accountTitle': accountTitle,
        'creationDate': creationDate,
        'amountType': amountType,
        'accountPortion': accountPortion,
        'currentAccountAmount': currentAccountAmount,
        'thisPaycheckCut': thisPaycheckCut
      };
}
