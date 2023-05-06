import 'package:flutter/material.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/view/widgets/wallet_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../widgets/wallet_balance_widget.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletController>(context);
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
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              StreamBuilder(
                stream: walletProvider.getWallets(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return WalletBalance(
                      balanceLabel: 'إجمالي الرصيد',
                      balance: walletProvider.getTotalBalance(snapshot.data!),
                      fontSize: 36,
                    );
                  } else {
                    return Container();
                  }
                }
              ),
              const SizedBox(height: 50),
              const Align(
                  alignment: Alignment.centerRight,
                  child:
                      Text('كل المحفظات', style: AppTextTheme.headerTextStyle)
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: walletProvider.getWallets(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if(snapshot.hasData && snapshot.hasError){
                    debugPrint(snapshot.error.toString());
                    return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
                  }

                  return Stack(
                    children:[data!.isEmpty? const Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle) :ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (_, index) => WalletWidget(
                        wallet: data[index],
                      ),
                      )
                    ],
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
