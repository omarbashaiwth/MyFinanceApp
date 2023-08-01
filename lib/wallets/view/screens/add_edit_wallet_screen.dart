import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/view/widgets/custom_text_form_field.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_bottom_sheets.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AddEditWalletScreen extends StatefulWidget {
  final Wallet? wallet;
  const AddEditWalletScreen({Key? key, this.wallet}) : super(key: key);

  @override
  State<AddEditWalletScreen> createState() => _AddEditWalletScreenState();
}

class _AddEditWalletScreenState extends State<AddEditWalletScreen> {
  final _walletFormKey = GlobalKey<FormState>();
  late final TextEditingController _balanceTextEditingController;
  late final TextEditingController _nameTextEditingController;

  @override
  void initState() {
    _balanceTextEditingController = TextEditingController(text: widget.wallet?.currentBalance.toString() ?? '');
    _nameTextEditingController = TextEditingController(text: widget.wallet?.name ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _balanceTextEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<WalletController>();
    final readProvider = context.read<WalletController>();
    final currentUser = FirebaseAuth.instance.currentUser;
    final walletToUpdate = widget.wallet;
    debugPrint('rebuild: ${watchProvider.walletType?.type ?? 'red'}');

    final newWallet = Wallet(
      createdAt: Timestamp.now(),
      walletType: watchProvider.walletType,
      userId: currentUser!.uid,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          title:  Text(walletToUpdate == null? 'إضافة محفظة جديدة':'تعديل المحفظة', style: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                  watchProvider.clearSelections();
                },
                icon:  Icon(Icons.close, color: Theme.of(context).colorScheme.onSecondary,),
            )
          ],
          leading: IconButton(
              onPressed: () async {
                final isValid = _walletFormKey.currentState!.validate();
                if(isValid) {
                  _walletFormKey.currentState!.save();
                  if(walletToUpdate == null && newWallet.walletType == null){
                    Fluttertoast.showToast(msg: 'اختر نوع المحفظة');
                  }
                  if(walletToUpdate == null && newWallet.walletType != null) {
                    await readProvider.insertWallet(newWallet);
                    Fluttertoast.showToast(msg: 'تم الإضافة');
                    watchProvider.clearSelections();
                    Get.back();
                  }
                  if(walletToUpdate != null && watchProvider.walletType == null){
                    readProvider.onWalletTypeChange(walletToUpdate.walletType!);
                  }
                  if(walletToUpdate != null){
                    final updatedWallet = Wallet(
                      name: _nameTextEditingController.text,
                      currentBalance: double.parse(_balanceTextEditingController.text),
                      id: walletToUpdate.id,
                      createdAt: walletToUpdate.createdAt,
                      walletType: watchProvider.walletType,
                      userId: walletToUpdate.userId,
                    );
                    await readProvider.updateWallet(wallet: updatedWallet);
                    Fluttertoast.showToast(msg: 'تم التحديث');
                    watchProvider.clearSelections();
                    Get.back();
                  }
                }
              },
              icon:  Icon(Icons.check, color: Theme.of(context).colorScheme.onSecondary,))
          ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _walletFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CustomTextFormField(
                      controller: _nameTextEditingController,
                      readOnly: false,
                      textFormKey: 'name',
                      hint: 'اسم المحفظة',
                      leadingIcon: Icons.text_format,
                      onSaved: (value) => newWallet.name = value
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                      controller: _balanceTextEditingController,
                      readOnly: false,
                      textFormKey: 'balance',
                      hint: 'الرصيد الحالي',
                      leadingIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => newWallet.currentBalance = double.parse(value),
                  ),
                  const SizedBox(height: 40),
                  // Align(alignment: Alignment.centerRight,child: Text('نوع المحفظة', style: AppTextTheme.headerTextStyle.copyWith(color: normalGray))),
                  // const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      WalletBottomSheets.showWalletTypesBS(
                        onSelected: (walletType) {
                          readProvider.onWalletTypeChange(walletType);
                        }
                    );
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.onPrimaryContainer
                        ),
                        child: Row(
                          children: [
                            Image.asset(watchProvider.walletType?.icon ?? walletToUpdate?.walletType?.icon ?? 'assets/icons/wallet.png', width: 24,),
                            const SizedBox(width: 8),
                            Text(watchProvider.walletType?.type ?? walletToUpdate?.walletType?.type ?? 'نوع المحفظة', style:  const TextStyle(fontFamily: 'Tajawal', color: lightGrey)),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
