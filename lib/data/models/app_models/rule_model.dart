// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class RuleModel {
  late String ruleID;
  late String ruleTitle;

  final String creationDate;

  RuleModel({
    String? ruleID,
    required this.ruleTitle,
    required this.creationDate,
  }) : ruleID = ruleID ?? '';

  RuleModel copyWith({
    String? ruleID,
    String? ruleTitle,
    String? creationDate,
  }) {
    return RuleModel(
      ruleID: ruleID ?? this.ruleID,
      ruleTitle: ruleTitle ?? this.ruleTitle,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  RuleModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : ruleID = doc.id,
        ruleTitle = doc['ruleTitle'],
        creationDate = doc['creationDate'];

  RuleModel.fromJson(Map<String, dynamic> json)
      : ruleID = json['ruleID'] as String,
        ruleTitle = json['ruleTitle'] as String,
        creationDate = json['creationDate'] as String;

  Map<String, dynamic> toJson() => {
        'ruleID': ruleID,
        'ruleTitle': ruleTitle,
        'creationDate': creationDate,
      };
}
