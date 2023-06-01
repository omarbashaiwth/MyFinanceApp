
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfinance_app/transactions/model/category.dart';

class Transaction{
  double? amount;
  Category? category;
  Timestamp? createdAt;
  String? walletId;
  String? note;
  String? userId;
  String? type;

  Transaction({this.walletId, this.category, this.createdAt, this.note, this.userId, this.type, this.amount});


  Map<String, dynamic> toFirestore() {
    return {
      if (category != null) 'category': category!.name,
      if (category != null) 'icon': category!.icon,
      if (amount != null) 'amount': amount,
      if (note != null) 'note':note,
      if(walletId != null) 'walletId':walletId else 'walletId': null,
      if(type != null) 'type': type,
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  factory Transaction.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Transaction(
        amount: data?['amount'],
        walletId: data?['walletId'],
        category: Category(
          name: data?['category'],
          icon: data?['icon'],
        ),
        type: data?['type'],
        note: data?['note'],
        userId: data?['userId'],
        createdAt: data?['createdAt']);
  }
}




