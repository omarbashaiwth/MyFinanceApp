import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/currency/model/currency.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;
  final Function() onCurrencySelected;
  final bool showSymbol;

  const CurrencyItem(
      {Key? key,
      required this.currency,
      required this.onCurrencySelected,
      required this.showSymbol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCurrencySelected,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                _flagWidget(currency.flag),
                const SizedBox(width: 8),
                Text(currency.name!,
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).hintColor)),
                // Text(
                //   currency.code!,
                //   style: const TextStyle(fontSize: 17),
                // ),
              ],
            )),
            showSymbol
                ? Text(
                    currency.symbol!,
                    style: const TextStyle(fontSize: 18),
                  )
                : const Icon(Icons.keyboard_arrow_left_rounded,
                    color: blackColor),
          ],
        ),
      ),
    );
  }

  Widget _flagWidget(String? flag) {
    if (flag == null) {
      return Image.asset(
        'assets/icons/no_flag.png',
        width: 27,
      );
    }
    if (flag.endsWith('png')) {
      return Image.asset(
        'assets/icons/xof.png',
        width: 27,
      );
    }

    return Text(
      Utils.emojiFlag(flag),
      style: const TextStyle(fontSize: 25),
    );
  }
}
