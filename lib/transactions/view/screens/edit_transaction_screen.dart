import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/currency/controller/currency_controller.dart';
import 'package:myfinance_app/transactions/controller/edit_transaction_controller.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transaction;
import 'package:myfinance_app/transactions/view/widgets/custom_text_form_field.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../widgets/clickable_text_field.dart';
import '../widgets/transaction_bottom_sheet.dart';

class EditTransactionScreen extends StatefulWidget {
  final my_transaction.Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {

  late EditTransactionController editController;
  late WalletController walletController;
  // late CurrencyController currencyController;
  late TextEditingController amountTextEditingController;
  late TextEditingController noteTextEditingController;
  
  @override
  void initState() {
    amountTextEditingController =
        TextEditingController(text: widget.transaction.amount?.toStringAsFixed(0));
    noteTextEditingController = TextEditingController(text: widget.transaction.note);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    editController = Provider.of<EditTransactionController>(context);
    walletController = Provider.of<WalletController>(context);
    // currencyController = Provider.of<CurrencyController>(context);

    final currentUser = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        editController.clearSelections();
        // walletController.clearSelections();
        // amountTextEditingController.dispose();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            title: Text(
              'تعديل المعاملة',
              style: AppTextTheme.appBarTitleTextStyle
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomTextFormField(
                      hint: '0.0',
                      onSaved: (value) {
                        widget.transaction.amount = double.parse(value);
                      },
                      textFormKey: 'amount',
                      keyboardType: TextInputType.number,
                      textSize: 24,
                      textAlign: TextAlign.center,
                      controller: amountTextEditingController,

                    ),
                  ),
                  // const SizedBox(height: 20,),
                  // StreamBuilder(
                  //   stream: walletController.getWallets(),
                  //   builder: (_, availableWallets) =>
                  //       FutureBuilder(
                  //         future: walletController.getWalletById(
                  //             widget.transaction.walletId!),
                  //         builder: (_, selectedWallet) {
                  //           debugPrint('selectedWallet: ${selectedWallet.data
                  //               ?.name}');
                  //           return ClickableTextField(
                  //             text: editController.selectedWallet?.walletType
                  //                 ?.type ?? selectedWallet.data?.name ??
                  //                 'خصم المبلغ من',
                  //             icon: editController.selectedWallet?.walletType
                  //                 ?.icon ??
                  //                 selectedWallet.data?.walletType?.icon ??
                  //                 'assets/icons/wallet.png',
                  //             color: Theme
                  //                 .of(context)
                  //                 .colorScheme
                  //                 .onPrimaryContainer,
                  //             onClick: () {
                  //               final expenseAmount =
                  //               double.tryParse(amountTextEditingController.text);
                  //               expenseAmount != null
                  //                   ? TransactionBottomSheet.showWalletsBS(
                  //                 title: 'خصم المبلغ من',
                  //                 currency: currencyController.currency?.symbol,
                  //                 userId: currentUser!.uid,
                  //                 onWalletClick: (wallet) {
                  //                     editController.onWalletChange(wallet);
                  //                     Get.back();
                  //                   },
                  //                 availableWallets: availableWallets.data!,
                  //                 walletClickable: (wallet) =>
                  //                 expenseAmount <= wallet.currentBalance!,
                  //               )
                  //                   : Fluttertoast.showToast(
                  //                   msg: 'قم بإدخال المبلغ أولاً');
                  //             },
                  //           );
                  //         },
                  //       ),
                  // ),
                  const SizedBox(height: 20,),
                  ClickableTextField(
                    text: editController.selectedCategory?.name ??
                        widget.transaction.category!.name!,
                    icon: editController.selectedCategory?.icon ??
                        widget.transaction.category!.icon!,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimaryContainer,
                    onClick: () {
                      TransactionBottomSheet.showExpensesIconsBS(
                          onClick: (index, category) {
                            editController.onCategoryChange(category);
                            Get.back();
                          },
                          selectedColor: (_) => lightGrey

                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  ClickableTextField(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onClick: () async {
                        final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.transaction.createdAt!.toDate(),
                            firstDate: DateTime(DateTime.now().year - 10),
                            lastDate: DateTime.now()
                        );
                        editController.onSelectedDateChange(Timestamp.fromDate(pickedDate!));
                      },
                      text: Utils.dateFormat(date: DateTime.fromMicrosecondsSinceEpoch(
                          editController.selectedDate?.microsecondsSinceEpoch ?? widget.transaction.createdAt!.microsecondsSinceEpoch
                      ),
                      ),
                      icon: 'assets/icons/calendar.png'
                  ),
                  const SizedBox(height: 20,),
                  CustomTextFormField(
                    textFormKey: 'note',
                    hint: 'ملاحظة (اختياري)',
                    isRequired: false,
                    readOnly: false,
                    leadingIcon: Icons.text_snippet_outlined,
                    controller: noteTextEditingController,
                    onSaved: (value) => widget.transaction.note = value,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () async {
                        await editController.updateTransaction(
                            transactionId: widget.transaction.id!,
                            data: my_transaction.Transaction(
                              id: widget.transaction.id,
                              amount: double.parse(amountTextEditingController.text),
                              category: editController.selectedCategory ?? widget.transaction.category,
                              createdAt: editController.selectedDate ?? widget.transaction.createdAt,
                              note: noteTextEditingController.text,
                              type: widget.transaction.type,
                              userId: widget.transaction.userId,
                              walletId: widget.transaction.walletId,
                            )
                        );
                        if(await walletController.getWalletById(widget.transaction.walletId!) != null){
                          await walletController.updateWalletBalance(
                            walletId: widget.transaction.walletId!,
                            value: widget.transaction.amount! - double.parse(amountTextEditingController.text),
                          );
                        }
                        Get.back();
                        // await walletController.updateWalletBalance(
                        //   walletId: editController.selectedWallet!.id!,
                        //   value: -(widget.transaction.amount! - double.parse(amountTextEditingController.text)),
                        // );
                        // await walletController.updateWalletBalance(
                        //   walletId: widget.transaction.walletId!,
                        //   value: widget.transaction.amount! - double.parse(amountTextEditingController.text),
                        // );
                        // Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "حفظ التعديلات",
                        style: AppTextTheme.elevatedButtonTextStyle,
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
