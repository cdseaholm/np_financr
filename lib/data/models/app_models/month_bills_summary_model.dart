// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyBillSummaryModel {
  late String docID;
  final String billSummaryPieceTitle;
  final String billSummaryPieceAmount;
  final String creationDate;

  MonthlyBillSummaryModel({
    String? docID,
    required this.billSummaryPieceTitle,
    required this.billSummaryPieceAmount,
    required this.creationDate,
  }) : docID = docID ?? '';

  MonthlyBillSummaryModel copyWith({
    String? docID,
    String? billSummaryPieceTitle,
    String? billSummaryPieceAmount,
    String? creationDate,
  }) {
    return MonthlyBillSummaryModel(
      docID: docID ?? this.docID,
      billSummaryPieceTitle:
          billSummaryPieceTitle ?? this.billSummaryPieceTitle,
      billSummaryPieceAmount:
          billSummaryPieceAmount ?? this.billSummaryPieceAmount,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  MonthlyBillSummaryModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        billSummaryPieceTitle = doc['billSummaryPieceTitle'],
        billSummaryPieceAmount = doc['billSummaryPieceAmount'],
        creationDate = doc['creationDate'];

  MonthlyBillSummaryModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        billSummaryPieceTitle = json['billSummaryPieceTitle'] as String,
        billSummaryPieceAmount = json['billSummaryPieceAmount'] as String,
        creationDate = json['creationDate'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'billSummaryPieceTitle': billSummaryPieceTitle,
        'billSummaryPieceAmount': billSummaryPieceAmount,
        'creationDate': creationDate,
      };
}
