import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/screens/wallet_details.dart';
import 'package:get/get.dart';

import '../../../core/widgets/price_widget.dart';

class WalletWidget extends StatelessWidget {
  final Wallet wallet;
  final TextEditingController addBalanceController;
  final TextEditingController transferBalanceController;
  final WalletController walletController;
  final String? currency;
  final Function() onAddBalance;
  final Function() onTransferBalance;
  final Function() onDeleteWalletOnly;
  final Function() onDeleteWalletAndTransactions;
  final Function() onClose;

  const WalletWidget(
      {Key? key,
      required this.wallet,
      required this.addBalanceController,
      required this.onAddBalance,
      required this.transferBalanceController,
      required this.walletController,
      required this.onTransferBalance,
      required this.onDeleteWalletOnly, required this.onClose, required this.currency, required this.onDeleteWalletAndTransactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => WalletDetails(
        wallet: wallet,
        addBalanceController: addBalanceController,
        transferBalanceController: transferBalanceController,
        onAddBalance: onAddBalance,
        onTransferBalance: onTransferBalance,
        onDeleteWalletOnly: onDeleteWalletOnly,
        onDeleteWalletAndTransactions: onDeleteWalletAndTransactions,
      )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: Get.isDarkMode ? Colors.transparent : lightGrey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: lightGrey, borderRadius: BorderRadius.circular(35)),
                  child: Image.asset(wallet.walletType!.icon, height: 35),
                ),
                const SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name!,
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(Get.context!).colorScheme.onPrimary),
                    ),
                    PriceWidget(
                      amount: wallet.currentBalance!,
                      currency: currency,
                      currencyFontSize: 14,
                      amountFontSize: 16,
                      color: wallet.currentBalance! < 0 ? red : green,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
