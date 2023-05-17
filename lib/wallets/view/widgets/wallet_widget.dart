import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/add_balance_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/transfer_balance_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_balance_widget.dart';
import 'package:get/get.dart';

class WalletWidget extends StatelessWidget {
  final Wallet wallet;
  final TextEditingController addBalanceController;
  final TextEditingController transferBalanceController;
  final WalletController walletController;
  final Function onAddBalance;
  final Function onTransferBalance;
  final Function onDeleteWallet;

  const WalletWidget(
      {Key? key,
      required this.wallet,
      required this.addBalanceController,
      required this.onAddBalance,
      required this.transferBalanceController,
      required this.walletController,
      required this.onTransferBalance,
      required this.onDeleteWallet})
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
              const SizedBox(height: 35),
              WalletBalance(
                balanceLabel: wallet.name!,
                balance: wallet.currentBalance!,
                fontSize: 28,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _walletAction(
                    label: 'إضافة',
                    icon: Icons.add,
                    onClick: () => showDialog(
                      context: context,
                      builder: (_) => AddBalanceDialog(
                        textEditingController: addBalanceController,
                        onPositiveClick: onAddBalance,
                      ),
                    ),
                  ),
                  _walletAction(
                      label: 'تحويل',
                      icon: Icons.currency_exchange,
                      onClick: () => showDialog(
                          context: context,
                          builder: (_) => TransferBalanceDialog(
                                textEditingController:
                                    transferBalanceController,
                                walletController: walletController,
                                transferFrom: wallet,
                                onPositiveClick: onTransferBalance,
                                userId: wallet.userId!,
                              ))),
                  _walletAction(
                      label: 'حذف',
                      icon: Icons.delete_rounded,
                      onClick: () {
                        Utils.showAlertDialog(
                            context: context,
                            positiveLabel: 'حذف',
                            negativeLabel: 'إغلاق',
                            title: 'تأكيد الحذف',
                            content: 'هل أنت متأكد من حذف هذه المحفظة؟ ',
                            onPositiveClick: (_) {
                              Get.back();
                              return onDeleteWallet();
                            },
                            onNegativeClick: (_) => Get.back());
                      })
                ],
              ),
              const SizedBox(height: 16),
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

  Widget _walletAction(
      {required String label,
      required IconData icon,
      required Function() onClick}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: redColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 24, color: whiteColor)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontFamily: 'Tajawal'),
        )
      ],
    );
  }
}
