import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/home/view/widgets/last_transactions.dart';
import 'package:provider/provider.dart';

import '../../controller/transaction_controller.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // actions: [
        //   IconButton(
        //       onPressed: () => Get.back(),
        //       icon: const Icon(Icons.keyboard_backspace)
        //   )
        // ],
        centerTitle: true,
        title: const Text(
          'سجل المعاملات',
          style: AppTextTheme.appBarTitleTextStyle,
        ),
      ),
      body: StreamBuilder(
          stream:
              Provider.of<TransactionController>(context).getTransactions(),
          builder: (context, snapshot) {
            final transactions = snapshot.data;
            if (snapshot.hasData && snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Align(
                  alignment: Alignment.center,
                  child:
                      Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }
            return Stack(children: [
              transactions!.isEmpty
                  ? const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'لا يوجد بيانات',
                        style: AppTextTheme.headerTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              TransactionHistoryItem(
                                transaction: transactions[index],
                              ),
                              index != transactions.indexOf(transactions.last)? const Divider():Container()
                            ],
                          ),
                        );
                      },
                    ),
            ]);
          }),
    );
  }
}
