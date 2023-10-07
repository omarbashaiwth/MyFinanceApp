import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/controller/edit_transaction_controller.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
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
  late TextEditingController amountTextEditingController;
  late TextEditingController noteTextEditingController;
  
  @override
  void initState() {
    amountTextEditingController =
        TextEditingController(text: widget.transaction.amount?.toString());
    noteTextEditingController = TextEditingController(text: widget.transaction.note);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editController = Provider.of<EditTransactionController>(context);
    walletController = Provider.of<WalletController>(context);

    return WillPopScope(
      onWillPop: () async {
        editController.clearSelections();
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
            leading: IconButton(
              onPressed: () {
                editController.clearSelections();
                Get.back();
              },
              icon:  Icon(
                Icons.arrow_back_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
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
                  const SizedBox(height: 20,),
                  StreamBuilder(
                    stream: editController.getUserCategories(widget.transaction.userId!),
                    builder: (context, snapshot) {
                      return ClickableTextField(
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
                              onIconClick: (index, category) {
                                editController.onCategoryChange(category);
                                Get.back();
                              },
                              onAddIconClick: (){},
                              selectedColor: (_) => lightGrey,
                              userCategories: snapshot.data ?? [],
                          );
                        },
                      );
                    }
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
                        final wallet = await walletController.getWalletById(widget.transaction.walletId!);
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
                        if(wallet != null){
                          await walletController.updateWalletBalance(
                            walletId: widget.transaction.walletId!,
                            value: widget.transaction.amount! - double.parse(amountTextEditingController.text),
                          );
                        }
                        Get.back();
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
