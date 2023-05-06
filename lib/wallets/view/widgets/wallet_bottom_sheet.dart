import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/theme.dart';
import '../../model/wallet_type.dart';

class WalletBottomSheet {
  static void show({required Function(WalletType walletType) onSelected}) {
    final walletType = [
      WalletType(type: 'كاش', icon: 'assets/icons/cash.png'),
      WalletType(type: 'حساب بنكي', icon: 'assets/icons/bank.png'),
      WalletType(type: 'أخرى', icon: 'assets/icons/expenses_icons/other.png'),
    ];
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4, right: 18, left: 18),
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
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
                itemCount: walletType.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      _designIcon(
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

  static Widget _designIcon(
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
}
