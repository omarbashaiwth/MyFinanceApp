import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/model/category.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transaction;
import 'package:myfinance_app/transactions/view/widgets/transaction_bottom_sheet.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';

import '../../../../core/ui/theme.dart';
import 'clickable_text_field.dart';
import 'custom_text_form_field.dart';

class TransactionForm {
  static Widget expenseForm(
      {required User currentUser,
      required TransactionController transactionController,
      required WalletController walletController,
      required my_transaction.Transaction transaction,
        required String? currency,
      required TextEditingController textEditingController,
      required BuildContext context,
        required Function onAddIconClick,
        required List<Category> userCategories,
      required Key key}) {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: orangeyRed)
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  child: CustomTextFormField(
                      textFormKey: 'amount',
                      textSize: 24,
                      textAlign: TextAlign.center,
                      hint: '0.0',
                      hintStyle: AppTextTheme.hintTextStyle.copyWith(fontSize: 24),
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      onSaved: (value) => transaction.amount =
                          double.tryParse(value),
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: walletController.getWallets(),
                  builder: (_, snapshot) {
                    return ClickableTextField(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,

                      text: transactionController.selectedWallet?.name ?? 'خصم المبلغ من',
                      icon:
                      transactionController.selectedWallet?.walletType?.icon ??
                          'assets/icons/wallet.png',
                      onClick: () {
                        final expenseAmount =
                        double.tryParse(textEditingController.text);
                        expenseAmount != null
                            ? TransactionBottomSheet.showWalletsBS(
                          title: 'خصم المبلغ من',
                          currency: currency,
                          userId: currentUser.uid,
                          availableWallets: snapshot.data!,
                          onWalletClick: (wallet){
                            transactionController.onWalletChange(wallet);
                            Get.back();
                          },
                          walletClickable: (wallet) => expenseAmount <= wallet.currentBalance!,
                        ) : Fluttertoast.showToast(msg: 'قم بإدخال المبلغ أولاً');
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                ClickableTextField(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  onClick: () => TransactionBottomSheet.showExpensesIconsBS(
                    userCategories: userCategories,
                    onAddIconClick: ()=> onAddIconClick(),
                    onIconClick: (index, category){
                      transactionController.onChangeSelectedIcon(index);
                      transactionController.onCategoryChange(category);
                      Get.back();
                    },
                    selectedColor: (index) =>
                        transactionController.selectedIcon == index
                            ? orangeyRed
                            : lightGrey
                  ),
                  text: transactionController.selectedCategory?.name ?? 'نوع النفقة',
                  icon: transactionController.selectedCategory?.icon ?? 'assets/icons/category.png',
                ),
                const SizedBox(height: 20),
                ClickableTextField(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onClick: () async {
                      final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 10),
                          lastDate: DateTime.now()
                      );
                      transactionController.onSelectedDateChange(Timestamp.fromDate(pickedDate!));
                    },
                    text: Utils.dateFormat(date: DateTime.fromMicrosecondsSinceEpoch(
                        transactionController.selectedDate.microsecondsSinceEpoch),
                    ),
                    icon: 'assets/icons/calendar.png'
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textFormKey: 'note',
                  hint: 'ملاحظة (اختياري)',
                  isRequired: false,
                  readOnly: false,
                  leadingIcon: Icons.text_snippet_outlined,
                  onSaved: (value) => transaction.note = value,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget incomeForm({
    required Key key,
    required User currentUser,
    required TransactionController transactionController,
    required WalletController walletController,
    required my_transaction.Transaction transaction,
    required String? currency,
    required BuildContext context,
  }) {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: green)
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  child: CustomTextFormField(
                    textFormKey: 'amount',
                    hint: '0.0',
                    textAlign: TextAlign.center,
                    textSize: 24,
                    hintStyle: AppTextTheme.hintTextStyle.copyWith(fontSize: 24),
                    keyboardType: TextInputType.number,
                    readOnly: false,
                    onSaved: (value) {
                      transaction.amount = double.parse(value);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textFormKey: 'name',
                  hint: 'اسم الدخل',
                  leadingIcon: Icons.text_snippet_outlined,
                  readOnly: false,
                  onSaved: (newValue) {
                    transaction.note = newValue;
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: walletController.getWallets(),
                  builder: (_, snapshot) {
                    return ClickableTextField(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      text: transactionController.selectedWallet?.name ?? 'إضافة المبلغ إلى',
                      icon:
                          transactionController.selectedWallet?.walletType?.icon ??
                              'assets/icons/wallet.png',
                      onClick: () => TransactionBottomSheet.showWalletsBS(
                        title: 'إضافة المبلغ إلى',
                        currency: currency,
                        userId: currentUser.uid,
                        availableWallets: snapshot.data!,
                        onWalletClick: (wallet){
                          transactionController.onWalletChange(wallet);
                          Get.back();
                        },
                        walletClickable: (_) => true,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ClickableTextField(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onClick: () async {
                      final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 12)
                      );
                      transactionController.onSelectedDateChange(Timestamp.fromDate(pickedDate!));
                    },
                    text: Utils.dateFormat(date: DateTime.fromMicrosecondsSinceEpoch(
                        transaction.createdAt!.microsecondsSinceEpoch)
                    ),
                    icon: 'assets/icons/calendar.png'
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
