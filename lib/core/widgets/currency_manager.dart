import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/theme.dart';
import '../utils/utils.dart';
import 'currencies_picker.dart';

class CurrencyManager {

  static showCurrencyPicker({required double bottomSheetHeight, required FirebaseFirestore firestore, required User user}){
    Get.bottomSheet(WillPopScope(
      onWillPop: () async =>  false,
      child: Container(
        height: bottomSheetHeight,
        decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                'اختر العملة',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 15),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CurrenciesPicker(
                currenciesList: Utils.currencies(),
                onCurrencySelected: (currency) async {
                  firestore.collection('Users')
                      .doc(user.uid)
                      .set({'username': user.displayName, 'email': user.email, 'currency': currency.symbol});
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    ),
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true
    );
  }

  static Future<bool> hasSelectedCurrency({required String userId, required FirebaseFirestore firestore}) async {
    final doc = await firestore.collection('Users').doc(userId).get();
    return doc.exists;
  }
}
