import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/model/category.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transaction;
import 'package:myfinance_app/transactions/view/widgets/centered_header.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/total_balance_widget.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_widget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../core/ui/theme.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({Key? key}) : super(key: key);

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  late final TextEditingController _addBalanceController;
  late final TextEditingController _transferBalanceController;

  @override
  void initState() {
    _addBalanceController = TextEditingController();
    _transferBalanceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addBalanceController.dispose();
    _transferBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final walletProvider = Provider.of<WalletController>(
        context, listen: false);
    final transactionProvider = Provider.of<TransactionController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
          elevation: 0,
          title: const Text(
            'المحفظات',
            style: AppTextTheme.appBarTitleTextStyle,
          ),
          centerTitle: true
      ),
      body: StreamBuilder(
          stream: walletProvider.getWallets(),
          builder: (_, snapshot) {
            debugPrint('Stream snapshot');
            final data = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                TotalBalanceWidget(
                    balance: snapshot.hasData? walletProvider.calculateTotalBalance(data!): 0.0 ,
                    currencyFontSize: 24,
                    amountFontSize: 36
                ),
                const SizedBox(height: 50),
                const CenteredHeader(header: 'كل المحفظات'),
                const SizedBox(height: 16),
                Expanded(
                    child: _allWallets(
                        snapshot: snapshot,
                        transactionController: transactionProvider,
                        walletController: walletProvider,
                        transferBalanceController: _transferBalanceController,
                        addBalanceController: _addBalanceController,
                        onClose: () {
                          transactionProvider.clearSelections();
                          Get.back();
                        },
                        onAddBalance: (wallet) async {
                          final valueToAdd = double.tryParse(
                              _addBalanceController.text);
                          if (valueToAdd == null) {
                            Fluttertoast.showToast(msg: 'قم بادخال مبلغ صحيح');
                          } else {
                            await walletProvider.updateWalletBalance(
                                value: valueToAdd,
                                walletId: wallet.id!
                            );
                            await transactionProvider.saveTransaction(
                                my_transaction.Transaction(
                                    amount: valueToAdd,
                                    walletId: wallet.id!,
                                    createdAt: Timestamp.now(),
                                    type: 'income',
                                    note: 'إضافة رصيد إلى ${wallet.name}',
                                    userId: auth.currentUser!.uid,
                                    category: Category(
                                        icon: wallet.walletType!.icon,
                                        name: 'إضافة رصيد',
                                    )
                                )
                            );
                            Get.back();
                          }
                        },
                        onTransferBalance: (from, to) async {
                          final transferAmount = double.tryParse(
                              _transferBalanceController.text);
                          if (transferAmount != null && to != null &&
                              transferAmount.isLowerThan(
                                  from.currentBalance!)) {
                            await walletProvider.updateWalletBalance(
                                value: -transferAmount,
                                walletId: from.id!
                            );
                            await walletProvider.updateWalletBalance(
                                value: transferAmount,
                                walletId: to.id!
                            );
                            await transactionProvider.saveTransaction(
                                my_transaction.Transaction(
                                    amount: transferAmount,
                                    walletId: from.id!,
                                    createdAt: Timestamp.now(),
                                    type: null,
                                    note: "تحويل من ${from.name} الى ${to
                                        .name}",
                                    userId: auth.currentUser!.uid,
                                    category: Category(
                                        icon: 'assets/icons/transfer.png',
                                        name: 'تحويل رصيد',
                                    )
                                )
                            );
                            transactionProvider.clearSelections();
                            Get.back();
                          }
                          else if (transferAmount == null) {
                            Fluttertoast.showToast(msg: 'قم بادخال مبلغ صحيح');
                          } else if (to == null) {
                            Fluttertoast.showToast(
                                msg: 'قم باختيار المحفظة المراد التحويل إليها');
                          } else if (transferAmount.isGreaterThan(
                              from.currentBalance!)) {
                            Fluttertoast.showToast(
                                msg: 'لا يوجد رصيد كافي للتحويل');
                          }
                        },
                        onDeleteWallet: (wallet) async {
                          await walletProvider.deleteWallet(
                              walletId: wallet.id!);
                        }
                    )
                )
                //
              ],
            );
          }),
    );
  }

  Widget _allWallets({required AsyncSnapshot<List<Wallet>> snapshot,
    required TextEditingController addBalanceController,
    required TextEditingController transferBalanceController,
    required TransactionController transactionController,
    required WalletController walletController,
    required Function(Wallet from, Wallet? to) onTransferBalance,
    required Function(Wallet) onAddBalance,
    required Function(Wallet) onDeleteWallet,
    required Function() onClose
  }) {
    final wallets = snapshot.data;
    if (snapshot.hasData && snapshot.hasError) {
      return const Align(
          alignment: Alignment.center,
          child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Align(
          alignment: Alignment.center, child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        wallets == null || wallets.isEmpty
            ? const EmptyWidget(
          message: 'لا يوجد محفظات.. قم بإضافة محفظة جديدة',)
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              itemCount: wallets.length,
              itemBuilder: (_, index) {
                return WalletWidget(
                  wallet: wallets[index],
                  addBalanceController: addBalanceController,
                  walletController: walletController,
                  transferBalanceController: transferBalanceController,
                  onAddBalance: () => onAddBalance(wallets[index]),
                  onTransferBalance: () =>
                      onTransferBalance(
                          wallets[index], transactionController.selectedWallet),
                  onDeleteWallet: () => onDeleteWallet(wallets[index]),
                  onClose: onClose,
                );
              }),
        )
      ],
    );
  }
}
