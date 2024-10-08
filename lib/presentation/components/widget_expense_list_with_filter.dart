import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_item.dart';

class WidgetExpenseListWithFilter extends StatelessWidget {
  final List<Expense> expensesFilter;
  const WidgetExpenseListWithFilter({super.key, required this.expensesFilter});

  @override
  Widget build(BuildContext context) {
    if (expensesFilter.isEmpty) {
      return const WidgetEmpty(
        subtitle: 'No expenses available yet',
      );
    }

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final Expense expense = expensesFilter[index];
          return WidgetExpenseListItem(expense: expense);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.teal,
            thickness: 0.5,
            indent: 40,
          );
        },
        itemCount: expensesFilter.length);
  }
}
