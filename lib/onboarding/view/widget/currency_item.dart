import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/onboarding/model/currency.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;
  final Function() onSelectCurrency;
  final bool isSelected;

  const CurrencyItem({Key? key, required this.currency, required this.onSelectCurrency, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectCurrency,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected? redColor: Colors.transparent),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                _flagWidget(currency.flag),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.code!,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(currency.name!,
                        style: TextStyle(
                            fontSize: 15, color: Theme.of(context).hintColor))
                  ],
                )
              ],
            )),
            Text(
              currency.symbol!,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flagWidget(String? flag){
    if(flag == null) {
      return Image.asset('assets/icons/no_flag.png', width: 27,);
    }
    if(flag.endsWith('png')){
      return Image.asset('assets/icons/xof.png', width: 27,);
    }

    return Text(
      Utils.emojiFlag(flag),
      style: const TextStyle(fontSize: 25),
    );
  }
}
