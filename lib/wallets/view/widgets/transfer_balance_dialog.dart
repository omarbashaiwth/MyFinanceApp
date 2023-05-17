import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/view/widgets/clickable_text_field.dart';
import 'package:myfinance_app/transactions/home/view/widgets/transaction_bottom_sheet.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';

class TransferBalanceDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onPositiveClick;
  final WalletController walletController;
  final Wallet transferFrom;
  final String userId;

  const TransferBalanceDialog({Key? key, required this.textEditingController, required this.onPositiveClick, required this.userId, required this.walletController, required this.transferFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionController>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  const Expanded(
                    child: Text(
                      'تحويل رصيد',
                      style: TextStyle(fontFamily: 'Tajawal'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: normalGray,
                    ),
                    splashRadius: 15,
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    'ريال',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.grey.shade100,
                    ),
                    width: 120,
                    child: TextField(
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClickableTextField(
                      onClick: (){},
                      color: Colors.grey.shade100,
                      text: transferFrom.name!,
                      image: transferFrom.walletType!.icon
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.arrow_downward, color: normalGray,),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: walletController.getWallets(),
                builder: (context, snapshot) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClickableTextField(
                          onClick: (){
                            TransactionBottomSheet.showWalletsBS(
                                userId: userId,
                                availableWallets: snapshot.data!
                            );
                          },
                          color: Colors.grey.shade100,
                          text: transactionProvider.selectedWallet.name ?? 'لا يوجد',
                          image: transactionProvider.selectedWallet.walletType?.icon ??
                              'assets/icons/question.png',
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: OutlinedButton(
                  onPressed: (){
                    onPositiveClick();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: redColor),
                    minimumSize: const Size(100, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child:  Text(
                    'تحويل',
                    style: AppTextTheme
                        .elevatedButtonTextStyle.copyWith(color: blackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ) ;
  }
}
