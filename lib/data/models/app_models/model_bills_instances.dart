import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userID = FirebaseAuth.instance.currentUser?.uid;

class BillInstancesModel {
  late String billInstanceID;
  late String monthlyUpdateID;
  late String instanceAmount;
  late String instanceDate;

  BillInstancesModel({
    String? billInstanceID,
    required this.monthlyUpdateID,
    required this.instanceAmount,
    required this.instanceDate,
  }) : billInstanceID = billInstanceID ?? '';

  BillInstancesModel copyWith({
    String? billInstanceID,
    String? monthlyUpdateID,
    String? instanceAmount,
    String? instanceDate,
  }) {
    return BillInstancesModel(
      billInstanceID: billInstanceID ?? this.billInstanceID,
      monthlyUpdateID: monthlyUpdateID ?? this.monthlyUpdateID,
      instanceAmount: instanceAmount ?? this.instanceAmount,
      instanceDate: instanceDate ?? this.instanceDate,
    );
  }

  BillInstancesModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : billInstanceID = doc.id,
        monthlyUpdateID = doc['monthlyUpdateID'],
        instanceAmount = doc['instanceAmount'],
        instanceDate = doc['instanceDate'];

  BillInstancesModel.fromJson(Map<String, dynamic> json)
      : billInstanceID = json['billInstanceID'] as String,
        monthlyUpdateID = json['monthlyUpdateID'] as String,
        instanceAmount = json['instanceAmount'] as String,
        instanceDate = json['instanceDate'] as String;

  Map<String, dynamic> toJson() => {
        'billInstanceID': billInstanceID,
        'monthlyUpdateID': monthlyUpdateID,
        'instanceAmount': instanceAmount,
        'instanceDate': instanceDate,
      };
}
