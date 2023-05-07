import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/home/view/widgets/appbar_with_tabs.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/transactions/home/view/widgets/transaction_form.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_form_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  final _expenseFormKey = GlobalKey<FormState>();
  final _incomeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    final tabController = TabController(length: 2, vsync: this);
    final currentUser = FirebaseAuth.instance.currentUser;
    final transactionController = Provider.of<TransactionController>(context);
    final walletController = Provider.of<WalletController>(context);
    final transaction = my_transaction.Transaction(
      type: 'expense',
      userId: currentUser!.uid,
      createdAt: Timestamp.now(),
      category: transactionController.selectedCategory,
      deductFrom: transactionController.selectedWallet.name,
    );


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: AppBarWithTabs(
          tabController: tabController,
          onIndexChange: (index) {
              currentIndex = index;
              currentIndex == 0? transaction.type = 'expense' : transaction.type = 'income';
              debugPrint('currentIndex: $currentIndex');
          },
          onCloseClicked: () {
            transactionController.clearSelections();
            Get.back();
          },
          onSaveClicked: () async {
            final provider =
                Provider.of<TransactionController>(context, listen: false);
            final isValid = tabController.index == 0
                ? _expenseFormKey.currentState!.validate()
                : _incomeFormKey.currentState!.validate();
            if (isValid) {
              tabController.index == 0
                  ? _expenseFormKey.currentState!.save()
                  : _incomeFormKey.currentState!.save();
              // save transaction to the firebase
              await provider.saveTransaction(transaction);
              // Fluttertoast.showToast(
              //     msg: "تتم الإضافة بنجاح",
              //
              // );
              provider.clearSelections();
              Get.back();
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            TransactionForm.expenseForm(
                key: _expenseFormKey,
                context: context,
                transaction: transaction,
                currentUser: currentUser,
                transactionController: transactionController,
                walletController: walletController,
            ),
            TransactionForm.incomeForm(
                key: _incomeFormKey,
                context: context,
                currentUser: currentUser,
                transaction: transaction,
                transactionController: transactionController,
                walletController: walletController,
            )
          ],
        ),
      ),
    );
  }
}
