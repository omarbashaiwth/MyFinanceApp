import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfinance_app/wallets/model/wallet_type.dart';

class Wallet {
  String? name;
  double? currentBalance;
  WalletType? walletType;
  String? userId;
  Timestamp? createdAt;

  Wallet({this.name, this.currentBalance, this.walletType, this.userId,this.createdAt});


  Map<String, dynamic> toFirestore() {
    return {
      if(name != null) 'name':name,
      if(currentBalance != null) 'balance':currentBalance,
      if(walletType != null) 'type': walletType!.type,
      if(walletType != null) 'icon': walletType!.icon,
      if(userId != null) 'userId': userId,
      if(createdAt != null) 'createdAt': createdAt,
  };
}

  factory Wallet.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ){
    final data = snapshot.data();
    return Wallet(
      name: data?['name'],
      currentBalance: data?['balance'],
      walletType: WalletType(type: data?['type'], icon: data?['icon'],),
      userId: data?['userId'],
      createdAt: data?['createdAt']
    );
  }




  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'balance': currentBalance,
  //     'type': walletType!.type,
  //     'icon': walletType!.icon,
  //     'userId': userId
  //   };
  // }
  //
  // factory Wallet.fromJson(Map<String, dynamic> json){
  //     return Wallet(
  //         name: json['name'],
  //         currentBalance: json['balance'],
  //         walletType: WalletType(type: json['type'], icon: json['icon']),
  //     userId: json['userId']
  //     );
  //
  // }

}