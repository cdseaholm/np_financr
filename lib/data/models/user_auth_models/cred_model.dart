// ignore_for_file: public_member_api_docs, sort_constructors_first, recursive_getters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CredModel {
  final String? userID;
  final String? displayName;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? customUsername;
  String filterView;
  String categoryFilter;
  String goalFilter;
  String statFilter;

  CredModel(
      {this.userID = '',
      required this.displayName,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.fullName,
      this.customUsername,
      String? filterView,
      String? categoryFilter,
      String? calendarView,
      String? goalFilter,
      String? statFilter})
      : filterView = filterView ?? 'All',
        categoryFilter = categoryFilter ?? 'All',
        goalFilter = goalFilter ?? 'Accounts',
        statFilter = statFilter ?? 'Accounts';

  CredModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : userID = snapshot.id,
        displayName = snapshot['display name'],
        email = snapshot['email'],
        firstName = snapshot['first name'],
        lastName = snapshot['last name'],
        fullName = snapshot['first name'] + snapshot['last name'],
        customUsername = snapshot['custom username'],
        filterView = snapshot['filterView'],
        categoryFilter = snapshot['categoryFilter'],
        goalFilter = snapshot['goalFilter'],
        statFilter = snapshot['statFilter'];

  CredModel.fromJson(Map<String, dynamic> json)
      : userID = FirebaseAuth.instance.currentUser?.uid as String,
        displayName = json['display name'] as String,
        email = json['email'] as String,
        firstName = json['first name'] as String,
        lastName = json['last name'] as String,
        fullName = json['full name'] as String,
        customUsername = json['custom username'] as String,
        filterView = json['filterView'] as String,
        categoryFilter = json['categoryFilter'] as String,
        goalFilter = json['goalFilter'] as String,
        statFilter = json['statFilter'] as String;

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'display name': displayName,
        'email': email,
        'first name': firstName,
        'last name': lastName,
        'full name': (firstName, lastName),
        'custom username': customUsername,
        'filterView': filterView,
        'categoryFilter': categoryFilter,
        'goalFilter': goalFilter,
        'statFilter': statFilter
      };
}
