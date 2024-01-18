import 'package:cloud_firestore/cloud_firestore.dart';

class UpdaterModel {
  late String updaterID;
  late String updaterTitle;
  late String updaterAmount;
  late String updatedDate;

  UpdaterModel({
    String? updaterID,
    required this.updaterTitle,
    required this.updaterAmount,
    required this.updatedDate,
  }) : updaterID = updaterID ?? '';

  UpdaterModel copyWith({
    String? updaterID,
    String? updaterTitle,
    String? updaterAmount,
    String? updatedDate,
  }) {
    return UpdaterModel(
      updaterID: updaterID ?? this.updaterID,
      updaterTitle: updaterTitle ?? this.updaterTitle,
      updaterAmount: updaterAmount ?? this.updaterAmount,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  UpdaterModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : updaterID = doc.id,
        updaterTitle = doc['updaterTitle'],
        updaterAmount = doc['updaterAmount'],
        updatedDate = doc['updatedDate'];

  UpdaterModel.fromJson(Map<String, dynamic> json)
      : updaterID = json['updaterID'] as String,
        updaterTitle = json['updaterTitle'] as String,
        updaterAmount = json['updaterAmount'] as String,
        updatedDate = json['updatedDate'] as String;

  Map<String, dynamic> toJson() => {
        'updaterID': updaterID,
        'updaterTitle': updaterTitle,
        'updaterAmount': updaterAmount,
        'updatedDate': updatedDate,
      };
}
