import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../currency/controller/currency_controller.dart';
import '../../../currency/view/currenciesBottomSheet.dart';
import '../../../currency/view/currency_item.dart';

class CurrencyWidget extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const CurrencyWidget({super.key, required this.auth, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyController>(
        builder: (context,currencyController,_){
          return FutureBuilder(
            future: currencyController.getCurrencyFromFirebase(firestore: firestore, userId: auth.currentUser!.uid),
            builder: (ctx, _) {
              return CurrencyItem(
                  currency: currencyController.currency!,
                  onCurrencySelected: () {
                    CurrenciesBottomSheet.show(
                        isDismissible: true,
                        willPop: true,
                        backgroundColor: Theme.of(context).colorScheme.onBackground,
                        onCurrencySelected: (currency)  async {
                          await currencyController.saveCurrency(
                              firestore: firestore,
                              user: auth.currentUser!,
                              currency: currency
                          );
                          Get.back();
                        },
                    );
                  },
                  showSymbol: false
              );
            },
          );
        }
    );
  }
}
