import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/expenses_icons.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/model/category.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/price_widget.dart';
import '../../../../wallets/model/wallet.dart';

class TransactionBottomSheet {
  static void showExpensesIconsBS(
        {required List<Category> userCategories,required Function onAddIconClick,required Function(int, Category ) onIconClick, required Color Function(int) selectedColor}
      ) {
    final iconsList = ExpensesIcons.iconsList + userCategories;
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      decoration:  BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.onBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // const SizedBox(height: 16),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              IconButton(
                  onPressed: () => onAddIconClick(),
                  icon: Icon(Icons.add, color: Theme.of(Get.context!).colorScheme.onPrimary,),
                splashRadius: 1,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('أختر نوع النفقة',
                style: TextStyle(fontFamily: 'Tajawal', color: Theme.of(Get.context!).colorScheme.onPrimary)),
              ),
            ]),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
                itemCount: iconsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (context, index) {
                  return _expenseCategoryItem(
                    icon: iconsList[index].icon!,
                    label: iconsList[index].name!,
                    color: selectedColor(index),
                    onClick: () => onIconClick(
                      index, iconsList[index]
                    )
                  );
                }),
          )
        ],
      ),
    ));
  }

  static void showWalletsBS({
    required String userId,
    required String title,
    required String? currency,
    required List<Wallet> availableWallets,
    required bool Function(Wallet) walletClickable,
    required Function(Wallet) onWalletClick,
  }) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      decoration:  BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.onBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(fontFamily: 'Tajawal')),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(children: [
                  availableWallets.isEmpty
                      ? const EmptyWidget(message: 'لا يوجد محفظات')
                      : ListView.builder(
                          itemCount: availableWallets.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              _walletItem(
                                  wallet: availableWallets[index],
                                  currency: currency,
                                  clickable: walletClickable,
                                  onClick: () {
                                    onWalletClick(availableWallets[index]);
                                  }),
                              const SizedBox(height: 12)
                            ]);
                          }),
                ]),
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
      required bool Function(Wallet) clickable,
      required String? currency}) {
    final colorFilter =
        ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.dstATop);
    return GestureDetector(
      onTap: clickable(wallet) ? onClick : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          clickable(wallet)
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
                    color: clickable(wallet)
                        ? Theme.of(Get.context!).colorScheme.onPrimary
                        : Colors.grey.withOpacity(0.2)),
              ),
              PriceWidget(
                amount: wallet.currentBalance!,
                currency: currency,
                color: !clickable(wallet)
                    ? Colors.grey.withOpacity(0.2)
                    : wallet.currentBalance! < 0
                        ? red
                        : green,
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
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Tajawal'),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
