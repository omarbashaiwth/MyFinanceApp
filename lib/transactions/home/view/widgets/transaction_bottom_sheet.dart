import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/price_widget.dart';
import '../../../../wallets/model/wallet.dart';

class TransactionBottomSheet {
  static void showExpensesIconsBS() {
    final iconsList = [
      Category(icon: 'assets/icons/expenses_icons/rent.png', name: 'إيجار'),
      Category(
          icon: 'assets/icons/expenses_icons/electricity.png', name: 'كهرباء'),
      Category(icon: 'assets/icons/expenses_icons/drop.png', name: 'ماء'),
      Category(icon: 'assets/icons/expenses_icons/wifi.png', name: 'إنترنت'),
      Category(
          icon: 'assets/icons/expenses_icons/shopping-cart.png', name: 'تسوق'),
      Category(icon: 'assets/icons/expenses_icons/bus.png', name: 'مواصلات'),
      Category(icon: 'assets/icons/expenses_icons/airplane.png', name: 'سفر'),
      Category(icon: 'assets/icons/expenses_icons/reading.png', name: 'تعليم'),
      Category(
          icon: 'assets/icons/expenses_icons/electrocardiography.png',
          name: 'صحة'),
      Category(
          icon: 'assets/icons/expenses_icons/gas-station.png', name: 'وقود'),
      Category(
          icon: 'assets/icons/expenses_icons/hot-air-balloon.png',
          name: 'ترفيه'),
      Category(
          icon: 'assets/icons/expenses_icons/shopping.png',
          name: 'مستلزمات البيت'),
      Category(icon: 'assets/icons/expenses_icons/zakat.png', name: 'صدقة'),
      Category(
          icon: 'assets/icons/expenses_icons/pending.png', name: 'كماليات'),
      Category(icon: 'assets/icons/expenses_icons/other.png', name: 'أخرى'),
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
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
                itemCount: iconsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (context, index) {
                  return _expenseCategoryItem(
                    icon: iconsList[index].icon,
                    label: iconsList[index].name,
                    color: Provider.of<TransactionController>(context)
                                .selectedIcon ==
                            index
                        ? redColor
                        : lightGray,
                    onClick: () {
                      Provider.of<TransactionController>(context, listen: false)
                          .onChangeSelectedIcon(index);
                      Provider.of<TransactionController>(context, listen: false)
                          .onCategoryChange(iconsList[index]);
                      Get.back();
                    },
                  );
                }),
          )
        ],
      ),
    ));
  }

  static void showWalletsBS(
      {required String userId,
      required List<Wallet> availableWallets,
      double? expenseAmount}) {
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
          const SizedBox(height: 16),
          const Text('المحفظات المتوفرة',
              style: TextStyle(fontFamily: 'Tajawal')),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                    itemCount: availableWallets.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        _walletItem(
                            expenseAmount: expenseAmount,
                            wallet: availableWallets[index],
                            onClick: () {
                              Provider.of<TransactionController>(context,
                                      listen: false)
                                  .onWalletChange(availableWallets[index]);
                              Get.back();
                            }),
                        const SizedBox(height: 12)
                      ]);
                      // return _expenseCategoryItem(
                      //   icon: availableWallets[index].walletType!.icon,
                      //   label: availableWallets[index].name!,
                      //   color: lightGray,
                      //   onClick: (){
                      //     Provider.of<TransactionController>(context, listen: false).onWalletChange(availableWallets[index]);
                      //     Get.back();
                      //   },
                      // );
                    }),
              ),
            ),
          )
        ],
      ),
    ));
  }

  static Widget _walletItem(
      {required Wallet wallet,
      required Function() onClick,
      required double? expenseAmount,
      String currency = 'ريال'}) {
    final canChooseWallet =  (expenseAmount != null &&
        expenseAmount.isLowerThan(wallet.currentBalance!)) || expenseAmount == null;
    final colorFilter =
        ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.dstATop);
    return GestureDetector(
      onTap: canChooseWallet ? onClick : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          canChooseWallet
              ? Image.asset(wallet.walletType!.icon, height: 35)
              : ClipOval(
                  child: ColorFiltered(
                    colorFilter: colorFilter,
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(wallet.walletType!.icon, height: 35),
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wallet.name!,
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    color: canChooseWallet
                        ? blackColor
                        : Colors.grey.withOpacity(0.2)),
              ),
              PriceWidget(
                amount: wallet.currentBalance!,
                currency: currency,
                fontSize: 13,
                color: !canChooseWallet
                    ? Colors.grey.withOpacity(0.2)
                    : wallet.currentBalance! < 0
                        ? Colors.red
                        : Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _expenseCategoryItem(
      {required String icon,
      required String label,
      required Color color,
      required Function onClick}) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: color),
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
