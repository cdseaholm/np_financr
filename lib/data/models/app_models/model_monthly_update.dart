// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyUpdateModel {
  late String docID;
  late String monthlyModelTitle;
  late String notes;
  late String datemonthlyModel;
  late String amount;
  final String creationDate;

  MonthlyUpdateModel({
    String? docID,
    required this.monthlyModelTitle,
    required this.notes,
    required this.datemonthlyModel,
    required this.amount,
    required this.creationDate,
  }) : docID = docID ?? '';

  MonthlyUpdateModel copyWith({
    String? docID,
    String? monthlyModelTitle,
    String? notes,
    String? datemonthlyModel,
    String? amount,
    String? creationDate,
  }) {
    return MonthlyUpdateModel(
      docID: docID ?? this.docID,
      monthlyModelTitle: monthlyModelTitle ?? this.monthlyModelTitle,
      notes: notes ?? this.notes,
      datemonthlyModel: datemonthlyModel ?? this.datemonthlyModel,
      amount: amount ?? this.amount,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  MonthlyUpdateModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        monthlyModelTitle = doc['monthlyModelTitle'],
        notes = doc['notes'],
        datemonthlyModel = doc['datemonthlyModel'],
        amount = doc['amount'],
        creationDate = doc['creationDate'];

  MonthlyUpdateModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        monthlyModelTitle = json['monthlyModelTitle'] as String,
        notes = json['notes'] as String,
        datemonthlyModel = json['datemonthlyModel'] as String,
        amount = json['amount'] as String,
        creationDate = json['creationDate'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'monthlyModelTitle': monthlyModelTitle,
        'notes': notes,
        'datemonthlyModel': datemonthlyModel,
        'amount': amount,
        'creationDate': creationDate,
      };
}
