import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  late String docID;
  late String goalTitle;
  final String creationDate;
  late String amount;
  late String type;
  late String account;
  late String color;
  late String completionDate;

  GoalModel({
    String? docID,
    required this.goalTitle,
    required this.creationDate,
    required this.amount,
    required this.type,
    required this.account,
    required this.color,
    required this.completionDate,
  }) : docID = docID ?? '';

  GoalModel copyWith(
      {String? docID,
      String? goalTitle,
      String? creationDate,
      String? amount,
      String? type,
      String? account,
      String? color,
      String? completionDate}) {
    return GoalModel(
        docID: docID ?? this.docID,
        goalTitle: goalTitle ?? this.goalTitle,
        creationDate: creationDate ?? this.creationDate,
        amount: amount ?? '0',
        type: type ?? 'account',
        account: account ?? '',
        color: color ?? '',
        completionDate: completionDate ?? '');
  }

  GoalModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        goalTitle = doc['goalTitle'],
        creationDate = doc['creationDate'],
        amount = doc['amount'],
        type = doc['type'],
        account = doc['account'],
        color = doc['color'],
        completionDate = doc['completionDate'];

  GoalModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        goalTitle = json['goalTitle'] as String,
        creationDate = json['creationDate'] as String,
        amount = json['amount'] as String,
        type = json['type'] as String,
        account = json['account'] as String,
        color = json['color'] as String,
        completionDate = json['completionDate'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'goalTitle': goalTitle,
        'creationDate': creationDate,
        'amount': amount,
        'type': type,
        'account': account,
        'color': color,
        'completionDate': completionDate
      };
}
