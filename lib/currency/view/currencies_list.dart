import 'package:flutter/material.dart';

import '../model/currency.dart';
import 'currency_item.dart';

class CurrenciesList extends StatelessWidget {
  final List<Currency> currenciesList;
  final Function(Currency) onCurrencySelected;
  const CurrenciesList({Key? key, required this.currenciesList,required this.onCurrencySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: currenciesList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final currency = currenciesList[index];
          return Column(
            children: [
              CurrencyItem(
                currency: currency,
                showSymbol: true,
                onCurrencySelected: () => onCurrencySelected(currency),
              ),
              const SizedBox(height: 4)
            ],
          );
        },
      ),
    );
  }
}
