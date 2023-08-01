import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/view/widgets/clickable_text_field.dart';
import 'package:myfinance_app/transactions/view/widgets/transaction_bottom_sheet.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../../../currency/controller/currency_controller.dart';

class TransferBalanceDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function() onPositiveClick;
  final Function() onClose;
  final WalletController walletController;
  final Wallet transferFrom;
  final String? currency;
  final String userId;

  const TransferBalanceDialog({Key? key, required this.textEditingController, required this.onPositiveClick, required this.userId, required this.walletController, required this.transferFrom, required this.onClose, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionController>(context);
    final currencyController = Provider.of<CurrencyController>(context);
    final firestore = FirebaseFirestore.instance;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      'تحويل رصيد',
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon:  Icon(
                      Icons.close,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    splashRadius: 15,
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   FutureBuilder(
                     future: currencyController.getCurrencyFromFirebase(firestore: firestore, userId: userId),
                     builder: (_,snapshot) => Text(
                       currencyController.currency?.symbol ?? '',
                      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 20, color: lightGrey),
                  ),
                   ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    width: 120,
                    child: TextField(
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClickableTextField(
                      onClick: (){},
                      color: Theme.of(context).colorScheme.background,
                      text: transferFrom.name!,
                      icon: transferFrom.walletType!.icon
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.arrow_downward, color:lightGrey,),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: walletController.getWallets(),
                builder: (context, snapshot) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClickableTextField(
                          onClick: (){
                            TransactionBottomSheet.showWalletsBS(
                                title: 'تحويل المبلغ إلى',
                                currency: currency,
                                userId: userId,
                                availableWallets: snapshot.data!,
                                walletClickable: (wallet ) => wallet.id != transferFrom.id
                            );
                          },
                          color: Theme.of(context).colorScheme.background,
                          text: transactionProvider.selectedWallet?.name ?? 'اختر المحفظة',
                          icon: transactionProvider.selectedWallet?.walletType?.icon ??
                              'assets/icons/wallet.png',
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 18),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(bottom: 20),
                child: OutlinedButton(
                  onPressed:  onPositiveClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child:  Text(
                    'تحويل',
                    style: AppTextTheme
                        .elevatedButtonTextStyle.copyWith(color: white, fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ) ;
  }
}
