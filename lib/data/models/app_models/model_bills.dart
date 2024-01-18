import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userID = FirebaseAuth.instance.currentUser?.uid;

class BillDetailsModel {
  late String billID;
  late String billTitle;
  late bool billPaid;
  late bool billWaived;
  late String creationDate;
  late String amount;

  BillDetailsModel({
    String? billID,
    required this.billTitle,
    required this.billPaid,
    required this.billWaived,
    required this.creationDate,
    required this.amount,
  }) : billID = billID ?? '';

  BillDetailsModel copyWith({
    String? billID,
    String? billTitle,
    bool? billPaid,
    bool? billWaived,
    String? creationDate,
    String? amount,
  }) {
    return BillDetailsModel(
      billID: billID ?? this.billID,
      billTitle: billTitle ?? this.billTitle,
      billPaid: billPaid ?? this.billPaid,
      billWaived: billWaived ?? this.billWaived,
      creationDate: creationDate ?? this.creationDate,
      amount: amount ?? this.amount,
    );
  }

  BillDetailsModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : billID = doc.id,
        billTitle = doc['billTitle'],
        billPaid = doc['billPaid'],
        billWaived = doc['billWaived'],
        creationDate = doc['creationDate'],
        amount = doc['amount'];

  BillDetailsModel.fromJson(Map<String, dynamic> json)
      : billID = json['billID'] as String,
        billTitle = json['billTitle'] as String,
        billPaid = json['billPaid'] as bool,
        billWaived = json['billWaived'] as bool,
        creationDate = json['creationDate'] as String,
        amount = json['amount'] as String;

  Map<String, dynamic> toJson() => {
        'billID': billID,
        'billTitle': billTitle,
        'billPaid': billPaid,
        'billWaived': billWaived,
        'creationDate': creationDate,
        'amount': amount
      };
}
