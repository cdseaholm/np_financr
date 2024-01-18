// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  late String docID;

  late String accountTitle;
  late String description;
  final String creationDate;
  late String amount;

  AccountModel({
    String? docID,
    required this.accountTitle,
    required this.description,
    required this.creationDate,
    required this.amount,
  }) : docID = docID ?? '';

  AccountModel copyWith({
    String? docID,
    String? accountTitle,
    String? description,
    String? creationDate,
    String? amount,
  }) {
    return AccountModel(
        docID: docID ?? this.docID,
        accountTitle: accountTitle ?? this.accountTitle,
        description: description ?? this.description,
        creationDate: creationDate ?? this.creationDate,
        amount: amount ?? '0');
  }

  AccountModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        accountTitle = doc['accountTitle'],
        description = doc['description'],
        creationDate = doc['creationDate'],
        amount = doc['amount'];

  AccountModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        accountTitle = json['accountTitle'] as String,
        description = json['description'] as String,
        creationDate = json['creationDate'] as String,
        amount = json['amount'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'accountTitle': accountTitle,
        'description': description,
        'creationDate': creationDate,
        'amount': amount,
      };
}
