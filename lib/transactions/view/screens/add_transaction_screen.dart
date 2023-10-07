import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfinance_app/core/utils/expenses_icons.dart';
import 'package:myfinance_app/transactions/model/category.dart';
import 'package:uuid/uuid.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/view/widgets/appbar_with_tabs.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/transactions/view/widgets/transaction_form.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:provider/provider.dart';

import '../../../currency/controller/currency_controller.dart';



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
  late final TextEditingController _newIconTextEditingController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _expenseTextEditingController = TextEditingController();
    _newIconTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _expenseTextEditingController.dispose();
    _newIconTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyController = Provider.of<CurrencyController>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final transactionController = Provider.of<TransactionController>(context);
    final walletController = Provider.of<WalletController>(context);
    final transaction = my_transaction.Transaction(
      type: _currentTabIndex == 0? 'expense': 'income',
      userId: currentUser!.uid,
      createdAt: transactionController.selectedDate,
      category: transactionController.selectedCategory,
      walletId: transactionController.selectedWallet?.id,
      id: const Uuid().v4()
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 2),
          child: AppBarWithTabs(
            tabController: _tabController,
            onIndexChange: (index) {
                setState(() => _currentTabIndex = index);
                transactionController.clearSelections();
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
              if (isValid && transaction.walletId != null && (transaction.category != null || _tabController.index == 1) ){
                _tabController.index == 0
                    ? _expenseFormKey.currentState!.save()
                    : _incomeFormKey.currentState!.save();
                // save transaction to the firebase
                await provider.saveTransaction(transaction);
                //update wallet balance
                await walletController.updateWalletBalance(
                    walletId: transaction.walletId! ,
                    value: transaction.type == 'expense'? -transaction.amount!:transaction.amount!,
                );
                provider.clearSelections();
                Get.back();
              } else if(isValid && transaction.walletId == null){
                Fluttertoast.showToast(
                  msg: 'قم باختيار المحفظة',
                );
              } else if(isValid && transaction.category == null) {
                Fluttertoast.showToast(
                  msg: 'قم باختيار نوع النفقة',
                );
              }
            },
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            StreamBuilder(
              stream: transactionController.getUserCategories(currentUser.uid),
              builder: (context, snapshot) {
                return TransactionForm.expenseForm(
                  key: _expenseFormKey,
                  textEditingController: _expenseTextEditingController,
                  context: context,
                  currency: currencyController.currency?.symbol ?? '',
                  transaction: transaction,
                  currentUser: currentUser,
                  transactionController: transactionController,
                  walletController: walletController,
                  userCategories: snapshot.data ?? [],
                  onAddIconClick:(){
                    showDialog(context: context, builder: (ctx){
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                              title:  Text('إضافة نوع نفقة جديد', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontFamily: 'Tajawal'), ),
                              content: TextField(
                                controller: _newIconTextEditingController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'اسم النفقة',
                                  hintStyle: TextStyle(fontFamily: 'Tajawal'),
                                ),
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                maxLength: 15,
                                maxLines: 1,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await transactionController.addNewCategory(
                                        currentUser.uid,
                                        Category(
                                            icon: 'assets/icons/expenses_icons/more.png',
                                            name: _newIconTextEditingController.text
                                        )
                                    );
                                    Get.back();
                                  },
                                  child: Text(
                                    "إضافة",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: 'Tajawal'),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "إلغاء",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontFamily: 'Tajawal'),
                                  )),
                            ],
                            ),
                          );
                        }
                    );
                  },
              );
              }
            ),
            TransactionForm.incomeForm(
                key: _incomeFormKey,
                context: context,
              currency: currencyController.currency?.symbol ?? '',
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
