import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/currency/model/currency.dart';

import '../../core/utils/utils.dart';
import 'currencies_list.dart';

class CurrenciesBottomSheet {
  static show({
    bool isDismissible = false,
    bool willPop = false,
    required Color backgroundColor,
    required Function(Currency) onCurrencySelected
  }) async {
    Get.bottomSheet(WillPopScope(
      onWillPop: () async =>  willPop,
      child: Container(
        decoration:  BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: CurrenciesList(
                  currenciesList: Utils.currencies(),
                  onCurrencySelected: onCurrencySelected
                ),
              ),
            )
          ],
        ),
      ),
    ),
        isDismissible: isDismissible,
        enableDrag: false,
        isScrollControlled: true
    );
  }

}

