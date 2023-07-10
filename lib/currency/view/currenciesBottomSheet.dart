import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/currency/model/currency.dart';

import '../../core/ui/theme.dart';
import '../../core/utils/utils.dart';
import 'currencies_list.dart';

class CurrenciesBottomSheet {
  static show({
    required double bottomSheetHeight,
    required Function(Currency) onCurrencySelected
  }) async {
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
              child: CurrenciesList(
                currenciesList: Utils.currencies(),
                onCurrencySelected: onCurrencySelected
                  // firestore.collection('Users')
                  //     .doc(user.uid)
                  //     .set({'username': user.displayName, 'email': user.email, 'currency': currency.symbol});
                  // Get.back();

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

}

