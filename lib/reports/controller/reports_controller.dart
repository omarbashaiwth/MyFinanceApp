import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/model/transaction.dart';

import '../model/expense_summray_model.dart';

class ReportsController extends ChangeNotifier{

  List<ExpenseSummaryModel> groupExpenses(
      List<Transaction> transactions) {
    final expenses =
    transactions.where((element) => element.type == 'expense').toList();
    // group expenses by category name
    final groupedExpenses =
    groupBy(expenses, (expense) => expense.category!.name);

    final categorySummary = groupedExpenses.entries.map((entry) {
      final categoryName = entry.key;
      final transactions = entry.value;
      final categoryTotalAmount = transactions.fold(
          0.0,
              (previousValue, transaction) =>
          previousValue + transaction.amount!);
      final categoryIcon = transactions.first.category!.icon;

      return ExpenseSummaryModel(
        name: categoryName!,
        value: categoryTotalAmount,
        icon: categoryIcon,
      );
    }).toList();
    // Sort category summaries by amount
    categorySummary.sort((a, b) => (a.value).compareTo(b.value));
    return categorySummary;
  }

  List<DateTime> getLastFiveMonths(){
    List<DateTime> months = [];
    for(int i = 0; i < 5; i++){
      final date = DateTime.now().subtract(Duration(days: 31 * i));
      months.add(date);
    }
    return months;
  }
}