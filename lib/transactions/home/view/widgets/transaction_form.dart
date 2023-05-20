import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart' as my_transaction;
import 'package:myfinance_app/transactions/home/view/widgets/transaction_bottom_sheet.dart';
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
      required TextEditingController textEditingController,
      required BuildContext context,
      required Key key}) {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextFormField(
                  textFormKey: 'name',
                  hint: 'الإسم',
                  leadingIcon: Icons.text_format,
                  readOnly: false,
                  onSaved: (value) => transaction.name = value),
              const SizedBox(height: 20),
              CustomTextFormField(
                  textFormKey: 'amount',
                  hint: 'المبلغ',
                  controller: textEditingController,
                  leadingIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  hasPrefix: true,
                  readOnly: false,
                  onSaved: (value) => transaction.category!.amount =
                      -int.parse(value).toDouble()),
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('خصم المبلغ من',
                      style: AppTextTheme.headerTextStyle
                          .copyWith(color: normalGray))),
              const SizedBox(height: 8),
              StreamBuilder(
                stream: walletController.getWallets(),
                builder: (_, snapshot) {
                  return ClickableTextField(
                    text: transactionController.selectedWallet.name ?? 'لا يوجد',
                    image:
                        transactionController.selectedWallet.walletType?.icon ??
                            'assets/icons/question.png',
                    onClick: () {
                      final expenseAmount =
                          double.tryParse(textEditingController.text);
                      expenseAmount != null
                          ? TransactionBottomSheet.showWalletsBS(
                              userId: currentUser.uid,
                              availableWallets: snapshot.data!,
                              walletClickable: (wallet) => expenseAmount
                                  .isLowerThan(wallet.currentBalance!),
                              // expenseAmount: expenseAmount,
                              // clickedWallet: null
                            )
                          : Fluttertoast.showToast(msg: 'قم بإدخال المبلغ أولاً');
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('نوع النفقة',
                      style: AppTextTheme.headerTextStyle
                          .copyWith(color: normalGray))),
              const SizedBox(height: 8),
              ClickableTextField(
                onClick: () => TransactionBottomSheet.showExpensesIconsBS(),
                text: transactionController.selectedCategory.name,
                image: transactionController.selectedCategory.icon,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'التاريخ',
                  style: AppTextTheme.headerTextStyle.copyWith(color: normalGray),
                ),
              ),
              const SizedBox(height: 8),
              ClickableTextField(
                  onClick: () async {
                    final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 12)
                    );
                    transactionController.onSelectedDateChange(Timestamp.fromDate(pickedDate!));
                  },
                  text: Utils.dateFormat(transaction.createdAt!),
                  image: 'assets/icons/calendar.png'
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                textFormKey: 'note',
                hint: 'ملاحظة (اختياري)',
                maxLines: 3,
                isRequired: false,
                readOnly: false,
                leadingIcon: Icons.text_snippet_outlined,
                onSaved: (value) => transaction.note = value,
              ),
            ],
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
    required BuildContext context,
  }) {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextFormField(
                textFormKey: 'name',
                hint: 'الإسم',
                leadingIcon: Icons.text_format,
                readOnly: false,
                onSaved: (newValue) {
                  transaction.name = newValue;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                textFormKey: 'amount',
                hint: 'المبلغ',
                leadingIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                readOnly: false,
                onSaved: (newValue) {
                  transaction.category!.amount = int.parse(newValue).toDouble();
                },
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('إضافة المبلغ إلى',
                      style: AppTextTheme.headerTextStyle
                          .copyWith(color: normalGray))),
              const SizedBox(height: 8),
              StreamBuilder(
                stream: walletController.getWallets(),
                builder: (_, snapshot) {
                  return ClickableTextField(
                    text: transactionController.selectedWallet.name ?? 'لا يوجد',
                    image:
                        transactionController.selectedWallet.walletType?.icon ??
                            'assets/icons/question.png',
                    onClick: () => TransactionBottomSheet.showWalletsBS(
                      userId: currentUser.uid,
                      availableWallets: snapshot.data!,
                      walletClickable: (_) => true,
                      // expenseAmount: null,
                      // clickedWallet: null
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'التاريخ',
                  style: AppTextTheme.headerTextStyle.copyWith(color: normalGray),
                ),
              ),
              const SizedBox(height: 8),
              ClickableTextField(
                  onClick: () async {
                    final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 12)
                    );
                    transactionController.onSelectedDateChange(Timestamp.fromDate(pickedDate!));
                  },
                  text: Utils.dateFormat(transaction.createdAt!),
                  image: 'assets/icons/calendar.png'
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                isRequired: false,
                textFormKey: 'note',
                hint: 'ملاحظة (اختياري)',
                leadingIcon: Icons.text_snippet_outlined,
                maxLines: 3,
                readOnly: false,
                onSaved: (newValue) {
                  transaction.note = newValue;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
