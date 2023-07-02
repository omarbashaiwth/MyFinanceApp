import 'package:flutter/material.dart';

import '../../onboarding/model/currency.dart';
import 'currency_item.dart';

class CurrenciesPicker extends StatelessWidget {
  final List<Currency> currenciesList;
  final Function(Currency) onCurrencySelected;
  const CurrenciesPicker({Key? key, required this.currenciesList,required this.onCurrencySelected}) : super(key: key);

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
                isSelected: false,
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
