// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PaycheckModel {
  late String docID;
  late String paycheckTitle;
  late String description;
  late String ruleID;
  late String ruleName;
  late String datepaycheck;
  late String amount;
  late String selectedAccount;
  final String creationDate;

  PaycheckModel({
    String? docID,
    required this.paycheckTitle,
    required this.description,
    required this.datepaycheck,
    String? ruleID,
    String? ruleName,
    required this.amount,
    required this.selectedAccount,
    required this.creationDate,
  })  : docID = docID ?? '',
        ruleID = ruleID ?? '',
        ruleName = ruleName ?? '';

  PaycheckModel copyWith({
    String? docID,
    String? paycheckTitle,
    String? description,
    String? datepaycheck,
    String? ruleID,
    String? ruleName,
    String? amount,
    String? selectedAccount,
    String? creationDate,
  }) {
    return PaycheckModel(
      docID: docID ?? this.docID,
      paycheckTitle: paycheckTitle ?? this.paycheckTitle,
      description: description ?? this.description,
      datepaycheck: datepaycheck ?? this.datepaycheck,
      ruleID: ruleID ?? this.ruleID,
      ruleName: ruleName ?? this.ruleName,
      amount: amount ?? this.amount,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  PaycheckModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        paycheckTitle = doc['paycheckTitle'],
        description = doc['description'],
        datepaycheck = doc['datepaycheck'],
        ruleID = doc['ruleID'],
        ruleName = doc['ruleName'],
        amount = doc['amount'],
        selectedAccount = doc['selectedAccount'],
        creationDate = doc['creationDate'];

  PaycheckModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        paycheckTitle = json['paycheckTitle'] as String,
        description = json['description'] as String,
        datepaycheck = json['datepaycheck'] as String,
        ruleID = json['ruleID'] as String,
        ruleName = json['ruleName'] as String,
        amount = json['amount'] as String,
        selectedAccount = json['selectedAccount'] as String,
        creationDate = json['creationDate'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'paycheckTitle': paycheckTitle,
        'description': description,
        'datepaycheck': datepaycheck,
        'ruleID': ruleID,
        'ruleName': ruleName,
        'amount': amount,
        'selectedAccount': selectedAccount,
        'creationDate': creationDate,
      };
}
