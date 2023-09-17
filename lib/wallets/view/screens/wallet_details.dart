import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/currency/controller/currency_controller.dart';
import 'package:myfinance_app/transactions/view/widgets/centered_header.dart';
import 'package:myfinance_app/transactions/view/widgets/transaction_history_item.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/screens/add_edit_wallet_screen.dart';
import 'package:myfinance_app/wallets/view/widgets/add_balance_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/alert_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/total_balance_widget.dart';
import 'package:myfinance_app/wallets/view/widgets/transfer_balance_dialog.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_bottom_sheets.dart';
import 'package:provider/provider.dart';

import '../../controller/wallet_controller.dart';

class WalletDetails extends StatelessWidget {
  final Wallet wallet;
  final TextEditingController addBalanceController;
  final TextEditingController transferBalanceController;
  final Function() onAddBalance;
  final Function() onTransferBalance;
  final Function() onDeleteWalletOnly;
  final Function() onDeleteWalletAndTransactions;
  const WalletDetails({super.key, required this.wallet, required this.onAddBalance, required this.onDeleteWalletOnly, required this.onTransferBalance, required this.addBalanceController, required this.transferBalanceController, required this.onDeleteWalletAndTransactions});

  @override
  Widget build(BuildContext context) {
    final walletController = Provider.of<WalletController>(context);
    final currencyController = Provider.of<CurrencyController>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSecondary,),
          ),
          title: Text(
              '${wallet.name}',
              style: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          actions: [
            IconButton(
                onPressed: (){
                  WalletBottomSheets.showWalletOptionsBT(
                      onEditClick: (){Get.to(() => AddEditWalletScreen(
                        wallet: wallet,
                      ));},
                      onAddBalanceClick: () => showDialog(
                          context: context,
                          builder: (_) => AddBalanceDialog(
                              textEditingController: addBalanceController,
                              onPositiveClick: onAddBalance
                          )
                      ),
                      onTransferBalanceClick: () => showDialog(
                          context: context,
                          builder: (_) => TransferBalanceDialog(
                              textEditingController: transferBalanceController,
                              onPositiveClick: onTransferBalance,
                              userId: wallet.userId!,
                              walletController: walletController,
                              transferFrom: wallet,
                              currency: currencyController.currency!.symbol,
                          )
                      ),
                      onDeleteClick: () => showDialog(
                          context: context,
                          builder: (ctx) => ShowAlertDialog(
                                title: 'تأكيد الحذف',
                                content: (controller) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          'هل أنت متأكد من حذف هذه المحفظة؟ '),
                                      const SizedBox(height: 50),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Text(
                                              'حذف المعاملات المرتبطة بالمحفظة'),
                                          Checkbox(
                                              activeColor: Theme.of(context).colorScheme.primary,
                                              value: controller
                                                  .deleteRelatedTransactions,
                                              onChanged: (value) => controller
                                                  .onToggleDeleteTransactions(value!)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                secondaryActionLabel: 'إغلاق',
                                onSecondaryActionClicked: () {
                                  walletController.onToggleDeleteTransactions(false);
                                  Get.back();
                                },
                                primaryActionLabel: 'حذف',
                                onPrimaryActionClicked: (controller) {
                                  controller.deleteRelatedTransactions? onDeleteWalletAndTransactions() :
                                  onDeleteWalletOnly();
                                  walletController.onToggleDeleteTransactions(false);
                                  Get.back();
                                },
                          ))
                      // onDeleteClick: () => Utils.showAlertDialog(
                      //     context: context,
                      //     title: 'تأكيد الحذف',
                      //     content: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         const Text('هل أنت متأكد من حذف هذه المحفظة؟ '),
                      //         CheckboxListTile(
                      //           value: walletController.deleteRelatedTransactions,
                      //           onChanged: (value) => walletController.onToggleDeleteTransactions(value!),
                      //           title: const Text('حذف المعاملات المرتبطة بالمحفظة'),
                      //         ),
                      //       ],
                      //     ),
                      //     primaryActionLabel: 'حذف',
                      //     secondaryActionLabel: 'إغلاق',
                      //     onPrimaryActionClicked: (){
                      //       onDeleteWallet();
                      //       Get.back();
                      //     },
                      //     onSecondaryActionClicked: () => Get.back()
                      // )
                  );
                },
                icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.onSecondary,))
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            TotalBalanceWidget(
                label: 'الرصيد الحالي',
                balance: wallet.currentBalance!,
                currencyFontSize:24,
                amountFontSize: 36,
                currency: currencyController.currency!.symbol
            ),
            const SizedBox(height: 30) ,
            const CenteredHeader(header: 'المعاملات المرتبطة بهذه المحفظة'),
            StreamBuilder(
              stream: walletController.getTransactionsRelatedToWallet(wallet.id!),
              builder: (context, snapshot){
                final transactions = snapshot.data ?? [];
                return Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
                        child: TransactionHistoryItem(
                            transaction: transactions[index],
                            currency: currencyController.currency!.symbol
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        )
      ),
    );
  }
}
