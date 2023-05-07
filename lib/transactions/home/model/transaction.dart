
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';

class Transaction{
  String? name;
  double? amount ;
  Category? category;
  Timestamp? createdAt;
  String? deductFrom;
  String? addTo;
  String? note;
  String? userId;
  String? type;

  Transaction({this.name, this.amount, this.addTo, this.category, this.createdAt, this.deductFrom, this.note, this.userId, this.type});


  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category!.category,
      if (category != null) 'icon': category!.icon,
      if (deductFrom != null) 'deductFrom':deductFrom,
      if (addTo != null) 'addTo':addTo,
      if (note != null) 'note':note,
      if (type != null) 'type':type,
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  factory Transaction.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Transaction(
        name: data?['name'],
        amount: data?['amount'],
        category: Category(
          category: data?['category'],
          icon: data?['icon'],
        ),
        deductFrom: data?['deductFrom'],
        addTo: data?['addTo'],
        type: data?['type'],
        note: data?['note'],
        userId: data?['userId'],
        createdAt: data?['createdAt']);
  }
}




