import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/screens/add_edit_wallet_screen.dart';
import 'package:myfinance_app/wallets/view/widgets/add_balance_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/transfer_balance_dialog.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_bottom_sheets.dart';

import '../../../core/widgets/price_widget.dart';

class WalletWidget extends StatelessWidget {
  final Wallet wallet;
  final TextEditingController addBalanceController;
  final TextEditingController transferBalanceController;
  final WalletController walletController;
  final String? currency;
  final Function() onAddBalance;
  final Function() onTransferBalance;
  final Function() onDeleteWallet;
  final Function() onClose;

  const WalletWidget(
      {Key? key,
      required this.wallet,
      required this.addBalanceController,
      required this.onAddBalance,
      required this.transferBalanceController,
      required this.walletController,
      required this.onTransferBalance,
      required this.onDeleteWallet, required this.onClose, required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: normalGray),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => WalletBottomSheets.showWalletOptionsBT(
                    onEditClick: () => Get.to(() => AddEditWalletScreen(wallet: wallet)),
                    onAddBalanceClick: () => showDialog(
                      context: context,
                      builder: (_) => AddBalanceDialog(
                        textEditingController: addBalanceController,
                        onPositiveClick: onAddBalance,
                      ),
                    ),
                    onTransferBalanceClick: () => showDialog(
                        context: context,
                        builder: (_) => TransferBalanceDialog(
                          textEditingController: transferBalanceController,
                          walletController: walletController,
                          currency: currency,
                          transferFrom: wallet,
                          onClose: onClose,
                          onPositiveClick: onTransferBalance,
                          userId: wallet.userId!,
                        ),
                    ),
                    onDeleteClick: () => Utils.showAlertDialog(
                        context: context,
                        primaryActionLabel: 'حذف',
                        secondaryActionLabel: 'إغلاق',
                        title: 'تأكيد الحذف',
                        content: 'هل أنت متأكد من حذف هذه المحفظة؟ ',
                        onPrimaryActionClicked: () {
                          Get.back();
                          return onDeleteWallet();
                          },
                        onSecondaryActionClicked: () => Get.back())
                  ),
                  icon: const Icon(Icons.more_vert, color: redColor,),
                  splashRadius: 18,
                ),
              ),
              Text(
                  wallet.name!,
                  style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                      color: blackColor),
              ),
              const SizedBox(height: 8),
              PriceWidget(
                amount: wallet.currentBalance!,
                currency: currency,
                currencyFontSize: 25,
                amountFontSize: 35,
                color: wallet.currentBalance! < 0 ? Colors.red: Colors.green,
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: normalGray, borderRadius: BorderRadius.circular(30)),
          child: Image.asset(wallet.walletType!.icon, height: 45),
        ),
      )
    ]);
  }
}
