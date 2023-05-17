import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/dialog_widget.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_balance_widget.dart';
import 'package:get/get.dart';

class WalletWidget extends StatelessWidget {
  final Wallet wallet;
  final TextEditingController textEditingController;
  final Function() onAddBalance;

  const WalletWidget(
      {Key? key,
      required this.wallet,
      required this.textEditingController,
      required this.onAddBalance})
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
                      onPressed: () {},
                      splashRadius: 18,
                      icon: const Icon(Icons.more_vert, size: 18))),
              WalletBalance(
                balanceLabel: wallet.name!,
                balance: wallet.currentBalance!,
                fontSize: 28,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _walletActions(
                    label: 'إضافة',
                    icon: Icons.add,
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomDialog(
                          textEditingController: textEditingController,
                          onPositiveClick: onAddBalance ,
                        ),
                      );
                    },
                  ),
                  _walletActions(
                      label: 'سحب',
                      icon: Icons.arrow_circle_down,
                      onClick: () {}),
                  _walletActions(
                      label: 'تحويل',
                      icon: Icons.currency_exchange,
                      onClick: () {}),
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

  Widget _walletActions(
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
