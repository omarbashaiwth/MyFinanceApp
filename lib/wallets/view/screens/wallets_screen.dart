import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart' as my_transaction;
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../widgets/wallet_balance_widget.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({Key? key}) : super(key: key);

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  late final TextEditingController _addBalanceController;

  @override
  void initState() {
    _addBalanceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final walletProvider = Provider.of<WalletController>(context, listen: false);
    final transactionProvider = Provider.of<TransactionController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor.withOpacity(.90),
        title: const Text(
          'المحفظات',
          style: AppTextTheme.appBarTitleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/icons/menu.png',
              height: 25,
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: walletProvider.getWallets(),
          builder: (_, snapshot) {
            debugPrint('Stream snapshot: $snapshot');
            // if(snapshot.hasError){
            //   return  Align(alignment: Alignment.center, child: Text(snapshot.error.toString(), style: AppTextTheme.headerTextStyle));
            // }
            final data = snapshot.data;
            if (data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text('فارغ', style: AppTextTheme.headerTextStyle));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  snapshot.hasData
                      ? WalletBalance(
                          balanceLabel: 'إجمالي الرصيد',
                          balance: walletProvider.calculateTotalBalance(data),
                          fontSize: 36,
                        )
                      : const WalletBalance(
                          balanceLabel: 'إجمالي الرصيد',
                          balance: 0.0,
                          fontSize: 36,
                        ),
                  const SizedBox(height: 50),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Text('كل المحفظات',
                          style: AppTextTheme.headerTextStyle)),
                  const SizedBox(height: 16),
                  _allWallets(
                      snapshot: snapshot,
                      textEditingController: _addBalanceController,
                      onAddBalance: (wallet)  async {
                        final valueToAdd = double.tryParse(_addBalanceController.text) ?? 0.0;
                        debugPrint('walletId: ${wallet.id}, value: ${_addBalanceController.text}');

                        await walletProvider.updateWallet(
                            value: valueToAdd,
                            walletId: wallet.id!
                        );
                        await transactionProvider.saveTransaction(
                           my_transaction.Transaction(
                             name: 'إضافة رصيد',
                             walletId: wallet.id!,
                             createdAt: Timestamp.now(),
                             type: 'income',
                             note: '',
                             userId: auth.currentUser!.uid,
                             category: Category(
                               icon: wallet.walletType!.icon,
                               name: 'أخرى',
                               amount: valueToAdd
                             )
                           )
                         );

                    }
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _allWallets(
      {required AsyncSnapshot<List<Wallet>> snapshot,
      required TextEditingController textEditingController,
        required  Function(Wallet) onAddBalance
      }) {
    final wallets = snapshot.data;
    if (wallets == null) {
      return const Align(
          alignment: Alignment.center,
          child: Text('فارغ', style: AppTextTheme.headerTextStyle));
    }
    if (snapshot.hasData && snapshot.hasError) {
      return const Align(
          alignment: Alignment.center,
          child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Align(
          alignment: Alignment.center, child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        wallets.isEmpty
            ? const SizedBox(
                width: double.infinity,
                child: Text(
                  'لا يوجد بيانات',
                  style: AppTextTheme.headerTextStyle,
                  textAlign: TextAlign.center,
                ))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: wallets.length,
                itemBuilder: (_, index) {
                  return WalletWidget(
                    wallet: wallets[index],
                    textEditingController: textEditingController,
                    onAddBalance: () => onAddBalance(wallets[index]),
                  );
                })
      ],
    );
  }
}
