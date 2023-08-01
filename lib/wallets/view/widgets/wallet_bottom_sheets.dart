import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/theme.dart';
import '../../model/wallet_type.dart';

class WalletBottomSheets {

  static void showWalletOptionsBT(
  {required Function onEditClick,
    required Function onAddBalanceClick,
    required Function onTransferBalanceClick,
    required Function onDeleteClick,
  }
      ){
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4, right: 18, left: 18),
          decoration:  BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.onBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightGrey),
                ),
                const SizedBox(height: 40),
                _walletOption(
                    label: 'تعديل المحفظة',
                    icon: Icons.edit,
                    onClick: () => onEditClick(),
                ),
                _walletOption(
                  label: 'إضافة رصيد إلى المحفظة',
                  icon: Icons.add,
                  onClick: () => onAddBalanceClick(),
                ),
                _walletOption(
                  label: 'تحويل رصيد إلى محفظة أخرى',
                  icon: Icons.currency_exchange,
                  onClick: () => onTransferBalanceClick(),
                ),
                _walletOption(
                  label: 'حذف المحفظة',
                  icon: Icons.delete_rounded,
                  onClick: onDeleteClick,
                ),
              ],

            ),
          ),
    )
    );
  }



  static void showWalletTypesBS({required Function(WalletType walletType) onSelected}) {
    final walletType = [
      WalletType(type: 'كاش', icon: 'assets/icons/cash.png'),
      WalletType(type: 'حساب بنكي', icon: 'assets/icons/bank.png'),
      WalletType(type: 'أخرى', icon: 'assets/icons/expenses_icons/other.png'),
    ];
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4, right: 18, left: 18),
      decoration:  BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.onBackground,
        borderRadius: const BorderRadius.only(
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
                color: lightGrey),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
                itemCount: walletType.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      _walletTypeDesignIcon(
                          icon: walletType[index].icon,
                          label: walletType[index].type,
                          onClick: () {
                            onSelected(walletType[index]);
                            Get.back();
                          },
                      ),
                      const SizedBox(height: 32)
                    ],
                  );
                },
            ),
          )
        ],
      ),
    ));
  }

  static Widget _walletTypeDesignIcon(
      {required String icon,
      required String label,
      required Function onClick}) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
          ),
          const SizedBox(width: 10),
          Image.asset(icon, height: 32),
        ],
      ),
    );
  }

  static Widget _walletOption(
      {required String label,
        required IconData icon,
        required Function onClick}) {
    return GestureDetector(
      onTap: () {
        Get.back();
        onClick();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: orangeyRed, borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(icon, size: 24, color: Theme.of(Get.context!).colorScheme.background)
                ),
                const SizedBox(width: 16),
                Text(label, style:  TextStyle(fontFamily: 'Tajawal', fontSize: 18, color: Theme.of(Get.context!).colorScheme.onPrimary),)

              ],
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
