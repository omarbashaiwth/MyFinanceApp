import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart';
import 'package:myfinance_app/transactions/home/view/widgets/transaction_bottom_sheet.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';

import '../../../../core/ui/theme.dart';
import 'clickable_text_field.dart';
import 'custom_text_form_field.dart';

class TransactionForm {

  static Widget expenseForm({
    required User currentUser,
    required TransactionController transactionController,
    required WalletController walletController,
    required Transaction transaction,
    required BuildContext context,
    required Key key
}){
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            customTextFormField(
                context: context,
                key: 'name',
                hint: 'الإسم',
                leadingIcon: Icons.text_format,
                readOnly: false,
                onSaved: (value) => transaction.name = value),
            const SizedBox(height: 20),
            customTextFormField(
                context: context,
                key: 'amount',
                hint: 'المبلغ',
                leadingIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                hasPrefix: true,
                readOnly: false,
                onSaved: (value) =>
                transaction.amount = -int.parse(value).toDouble()),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerRight,
                child: Text('خصم المبلغ من',
                    style: AppTextTheme.headerTextStyle
                        .copyWith(color: normalGray))),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: walletController.getWallets(),
              builder: (context, snapshot) {
                return ClickableTextField(
                  text: transactionController.selectedWallet.name ??
                      'لا يوجد',
                  image: transactionController
                      .selectedWallet.walletType?.icon ??
                      'assets/icons/question.png',
                  onClick: () => TransactionBottomSheet(context).showWalletsBS(
                    userId: currentUser.uid,
                    availableWallets: snapshot.data!,
                  ),
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
              onClick: () => TransactionBottomSheet(context).showExpensesIconsBS(),
              text: transactionController.selectedCategory.category,
              image: transactionController.selectedCategory.icon,
            ),
            const SizedBox(height: 20),
            customTextFormField(
              context: context,
              key: 'note',
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
    );
  }

  static Widget incomeForm({
    required Key key,
    required User currentUser,
    required TransactionController transactionController,
    required WalletController walletController,
    required Transaction transaction,
    required BuildContext context,
  }){
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            customTextFormField(
              context: context,
              key: 'name',
              hint: 'الإسم',
              leadingIcon: Icons.text_format,
              readOnly: false,
              onSaved: (newValue) {
                transaction.name = newValue;
              },
            ),
            const SizedBox(height: 20),
            customTextFormField(
              context: context,
              key: 'amount',
              hint: 'المبلغ',
              leadingIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              readOnly: false,
              onSaved: (newValue) {
                transaction.amount = int.parse(newValue).toDouble();
              },
            ),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerRight,
                child: Text('خصم المبلغ من',
                    style: AppTextTheme.headerTextStyle
                        .copyWith(color: normalGray))),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: walletController.getWallets(),
              builder: (context, snapshot) {
                return ClickableTextField(
                  text: transactionController.selectedWallet.name ??
                      'لا يوجد',
                  image: transactionController
                      .selectedWallet.walletType?.icon ??
                      'assets/icons/question.png',
                  onClick: () => TransactionBottomSheet(context).showWalletsBS(
                    userId: currentUser.uid,
                    availableWallets: snapshot.data!,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            customTextFormField(
              context: context,
              isRequired: false,
              key: 'note',
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
    );
  }
}
