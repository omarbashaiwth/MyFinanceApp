import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../widgets/wallet_balance_widget.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletController>(context, listen: false);
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
            if(data == null) {
              return const Align(alignment: Alignment.center, child: Text('فارغ', style: AppTextTheme.headerTextStyle));

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
                  _allWallets(snapshot: snapshot)
                ],
              ),
            );
          }),
    );
  }

  Widget _allWallets({required AsyncSnapshot<List<Wallet>> snapshot}){
      final wallets = snapshot.data;
      if(wallets == null) {
        return const Align(alignment: Alignment.center, child: Text('فارغ', style: AppTextTheme.headerTextStyle));
      }
      // if(snapshot.hasError){
      //   throw snapshot.error.toString();
      //   debugPrint(snapshot.error.toString());
      //   return  Align(alignment: Alignment.center, child: Text(snapshot.error.toString(), style: AppTextTheme.headerTextStyle));
      //
      // }
      if(snapshot.hasData && snapshot.hasError){
        return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
      }
      return Stack(
        children: [
          wallets.isEmpty? const SizedBox(width: double.infinity, child: Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,))
              : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: wallets.length,
              itemBuilder: (_,index){
                return WalletWidget(wallet: wallets[index]);
              }
          )
        ],
      );
  }
}
