import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/transactions/view/widgets/transaction_history_item.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../controller/transaction_controller.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: redColor,),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
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
                  ? const EmptyWidget()
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
                              index != transactions.indexOf(transactions.last)? const Divider():const SizedBox(height: 10,)
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
