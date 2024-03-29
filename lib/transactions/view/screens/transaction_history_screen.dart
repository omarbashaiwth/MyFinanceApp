import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/transactions/view/widgets/centered_header.dart';
import 'package:myfinance_app/transactions/view/widgets/transaction_history_item.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../controller/transaction_controller.dart';
import 'edit_transaction_screen.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final String? currency;
  const TransactionHistoryScreen({Key? key, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon:  Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title:  Text(
          'سجل المعاملات',
          style: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
      body: StreamBuilder(
          stream: Provider.of<TransactionController>(context).getTransactions(),
          builder: (context, snapshot) {
            final transactions = snapshot.data;
            if (snapshot.hasData && snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return  Align(
                  alignment: Alignment.center,
                  child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle.copyWith(color:Theme.of(context).colorScheme.onPrimary)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }
            return Stack(children: [
              transactions!.isEmpty
                  ? const EmptyWidget()
                  : GroupedListView(
                      elements: transactions,
                      groupBy: (transaction) {
                        final date = transaction.createdAt!.toDate();
                        return DateTime(date.year, date.month );
                      },
                      groupSeparatorBuilder: (date) {
                        return CenteredHeader(header: Utils.dateFormat(date: date, showDays: false));
                      },
                      itemBuilder: (_, transaction) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              TransactionHistoryItem(
                                transaction: transaction,
                                currency: currency,
                                onItemClicked: () => Get.to(() =>
                                    EditTransactionScreen(
                                        transaction: transaction)),
                              ),
                              // index != transactions.indexOf(transactions.last)?
                            ],
                          ),
                        );
                      },
                      sort: false,
                      separator: const Divider(),
                      order: GroupedListOrder.DESC,
                      stickyHeaderBackgroundColor: Theme.of(context).colorScheme.background,
                      useStickyGroupSeparators: true,
                    )
            ]);
          }),
    );
  }
}
