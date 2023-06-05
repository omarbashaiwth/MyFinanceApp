import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';
import '../../model/currency.dart';
import 'currency_item.dart';

class CurrenciesPicker extends StatelessWidget {
  final List<Currency> currenciesList;
  final bool Function(Currency) isSelected;
  final Function(Currency) onCurrencySelected;
  const CurrenciesPicker({Key? key, required this.currenciesList, required this.isSelected, required this.onCurrencySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: lightGray, borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            itemCount: currenciesList.length,
            itemBuilder: (_, index) {
              final currency = currenciesList[index];
              return Column(
                children: [
                  CurrencyItem(
                    currency: currency,
                    isSelected: isSelected(currency),
                    onCurrencySelected: () => onCurrencySelected(currency),
                  ),
                  const SizedBox(height: 4)
                ],
              );
            },
          )),
    );
  }
}
