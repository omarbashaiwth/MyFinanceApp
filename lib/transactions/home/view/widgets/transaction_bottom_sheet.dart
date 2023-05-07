import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:provider/provider.dart';

import '../../../../wallets/model/wallet.dart';


class TransactionBottomSheet {
  final BuildContext context;

  TransactionBottomSheet(this.context);

  void showExpensesIconsBS(){
    final iconsList = [
      Category(icon: 'assets/icons/expenses_icons/rent.png',category: 'إيجار'),
      Category(icon: 'assets/icons/expenses_icons/electricity.png',category:  'كهرباء'),
      Category(icon: 'assets/icons/expenses_icons/drop.png',category:  'ماء'),
      Category(icon: 'assets/icons/expenses_icons/wifi.png',category:  'إنترنت'),
      Category(icon: 'assets/icons/expenses_icons/shopping-cart.png',category:  'تسوق'),
      Category(icon: 'assets/icons/expenses_icons/bus.png',category:  'مواصلات'),
      Category(icon: 'assets/icons/expenses_icons/airplane.png',category:  'سفر'),
      Category(icon: 'assets/icons/expenses_icons/reading.png',category:  'تعليم'),
      Category(icon: 'assets/icons/expenses_icons/electrocardiography.png',category:  'صحة'),
      Category(icon: 'assets/icons/expenses_icons/gas-station.png',category:  'وقود'),
      Category(icon: 'assets/icons/expenses_icons/hot-air-balloon.png',category:  'ترفيه'),
      Category(icon: 'assets/icons/expenses_icons/shopping.png',category:  'مستلزمات البيت'),
      Category(icon: 'assets/icons/expenses_icons/zakat.png', category: 'صدقة'),
      Category(icon: 'assets/icons/expenses_icons/pending.png', category: 'كماليات'),
      Category(icon: 'assets/icons/expenses_icons/other.png', category: 'أخرى'),
    ];
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
                itemCount: iconsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (_, index) {
                  return _designIcon(
                    icon: iconsList[index].icon,
                    label: iconsList[index].category,
                    color: Provider.of<TransactionController>(context).selectedIcon == index? redColor:lightGray,
                    onClick: (){
                      Provider.of<TransactionController>(context, listen: false).onChangeSelectedIcon(index);
                      Provider.of<TransactionController>(context, listen: false).onCategoryChange(iconsList[index]);
                      Get.back();
                    },
                  );
                }),
          )
        ],
      ),
    ));
  }

  Future<void> showWalletsBS({required String userId, required List<Wallet> availableWallets})async {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
                itemCount: availableWallets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (_, index) {
                  return _designIcon(
                    icon: availableWallets[index].walletType!.icon,
                    label: availableWallets[index].name!,
                    color: lightGray,
                    onClick: (){
                      Provider.of<TransactionController>(context, listen: false).onWalletChange(availableWallets[index]);
                      Get.back();
                    },
                  );
                }),
          )
        ],
      ),
    ));
  }



  static Widget _designIcon(
      {required String icon,
        required String label,
        required Color color,
        required Function onClick
      }) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color
            ),
            child: Image.asset(icon, height: 35),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Tajawal'),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}



