import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/view/widgets/custom_text_form_field.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AddWalletScreen extends StatelessWidget {
  final _walletFormKey = GlobalKey<FormState>();

  AddWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletController>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final wallet = Wallet(
      createdAt: Timestamp.now(),
      walletType: walletProvider.walletType,
      userId: currentUser!.uid
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('إضافة محفظة جديدة', style: AppTextTheme.appBarTitleTextStyle),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, color: redColor,))
        ],
        leading: IconButton(
            onPressed: () async {
              final isValid = _walletFormKey.currentState!.validate();
              if(isValid) {
                _walletFormKey.currentState!.save();
                await Provider.of<WalletController>(context, listen: false).insertWallet(wallet);
                Get.back();
              }
            },
            icon: const Icon(Icons.check, color: Colors.red,))
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
                    readOnly: false,
                    textFormKey: 'name',
                    hint: 'اسم المحفظة',
                    leadingIcon: Icons.text_format,
                    onSaved: (value) => wallet.name = value
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                    readOnly: false,
                    textFormKey: 'balance',
                    hint: 'الرصيد الحالي',
                    leadingIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    onSaved: (value) => wallet.currentBalance = double.parse(value),
                ),
                const SizedBox(height: 40),
                Align(alignment: Alignment.centerRight,child: Text('نوع المحفظة', style: AppTextTheme.headerTextStyle.copyWith(color: normalGray))),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    WalletBottomSheet.show(
                      onSelected: (walletType) {
                        Provider.of<WalletController>(context, listen: false).onWalletTypeChange(walletType);
                      }
                  );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.secondaryContainer
                      ),
                      child: Row(
                        children: [
                          Image.asset(walletProvider.walletType.icon, width: 24,),
                          const SizedBox(width: 8),
                          Text(walletProvider.walletType.type, style: const TextStyle(fontFamily: 'Tajawal')),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
