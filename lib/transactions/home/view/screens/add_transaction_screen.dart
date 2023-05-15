import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/home/view/widgets/appbar_with_tabs.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/transactions/home/view/widgets/transaction_form.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:provider/provider.dart';

import '../widgets/transaction_bottom_sheet.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  final _expenseFormKey = GlobalKey<FormState>();
  final _incomeFormKey = GlobalKey<FormState>();
  var _currentTabIndex = 0;
  late final TabController _tabController;
  late final TextEditingController _expenseTextEditingController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _expenseTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _expenseTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = FirebaseAuth.instance.currentUser;
    final transactionController = Provider.of<TransactionController>(context);
    final walletController = Provider.of<WalletController>(context);
    final transaction = my_transaction.Transaction(
      type: _currentTabIndex == 0? 'expense': 'income',
      userId: currentUser!.uid,
      createdAt: Timestamp.now(),
      category: transactionController.selectedCategory,
      walletId: transactionController.selectedWallet.id,
    );


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: AppBarWithTabs(
          tabController: _tabController,
          onIndexChange: (index) {
              setState(() => _currentTabIndex = index);
          },
          onCloseClicked: () {
            transactionController.clearSelections();
            Get.back();
          },
          onSaveClicked: () async {
            final provider =
                Provider.of<TransactionController>(context, listen: false);
            final isValid = _tabController.index == 0
                ? _expenseFormKey.currentState!.validate()
                : _incomeFormKey.currentState!.validate();
            if (isValid && transaction.walletId != null) {
              _tabController.index == 0
                  ? _expenseFormKey.currentState!.save()
                  : _incomeFormKey.currentState!.save();
              // save transaction to the firebase
              await provider.saveTransaction(transaction);
              await walletController.updateWallet(
                  walletId: transaction.walletId! ,
                  value: transaction.category!.amount!,
              );
              provider.clearSelections();
              Get.back();
            } else{
              Fluttertoast.showToast(
                msg: 'قم باختيار المحفظة',
              );
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            TransactionForm.expenseForm(
                key: _expenseFormKey,
                textEditingController: _expenseTextEditingController,
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
