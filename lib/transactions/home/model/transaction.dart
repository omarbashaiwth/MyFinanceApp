
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';

class Transaction{
  String? name;
  double? amount ;
  Category? category;
  Timestamp? date;
  String? deductFrom;
  String? addTo;
  String? note;
  String? userId;
  String? type;

  Transaction({this.name, this.amount, this.addTo, this.category, this.date, this.deductFrom, this.note, this.userId, this.type});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'categoryName': category!.label,
      'categoryIcon' : category!.icon,
      'date': date,
      'deductFrom' :deductFrom,
      'addTo':addTo,
      'note':note,
      'userId' : userId,
      'type' : type
    };
  }

  Transaction.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    category!.label = json['categoryName'];
    category!.icon = json['categoryIcon'];
    date = json['date'];
    deductFrom = json['deductFrom'];
    addTo = json['addTo'];
    note = json['note'];
    userId = json['userId'];
    type = json['type'];
  }
}




