// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  late String docID;

  late String cardTitle;
  late String description;
  final String creationDate;
  late String amount;

  CardModel({
    String? docID,
    required this.cardTitle,
    required this.description,
    required this.creationDate,
    required this.amount,
  }) : docID = docID ?? '';

  CardModel copyWith({
    String? docID,
    String? cardTitle,
    String? description,
    String? creationDate,
    String? amount,
  }) {
    return CardModel(
        docID: docID ?? this.docID,
        cardTitle: cardTitle ?? this.cardTitle,
        description: description ?? this.description,
        creationDate: creationDate ?? this.creationDate,
        amount: amount ?? '0');
  }

  CardModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        cardTitle = doc['cardTitle'],
        description = doc['description'],
        creationDate = doc['creationDate'],
        amount = doc['amount'];

  CardModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        cardTitle = json['cardTitle'] as String,
        description = json['description'] as String,
        creationDate = json['creationDate'] as String,
        amount = json['amount'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'cardTitle': cardTitle,
        'description': description,
        'creationDate': creationDate,
        'amount': amount,
      };
}
