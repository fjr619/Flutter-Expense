import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_without_filter.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  final bool all;
  final bool canScroll;

  const ExpenseListScreen({
    super.key,
    required this.all,
    this.canScroll = false,
  });

  @override
  ConsumerState<ExpenseListScreen> createState() => _WidgetExpenseListState();
}

class _WidgetExpenseListState extends ConsumerState<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
    final exepsneListVM = ref.read(expenseListViewmodelProvider.notifier);

    if (widget.all) {
      exepsneListVM.getAllExpense();
    } else {
      exepsneListVM.getTodayExpense();
    }
  }

  Future<void> dismissExpense(Expense expense) async {
    final exepsneListVM = ref.read(expenseListViewmodelProvider.notifier);
    await exepsneListVM.deleteExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    final expenseListViewmodel = ref.watch(expenseListViewmodelProvider);

    if ((widget.all && expenseListViewmodel.expensesAll.isEmpty) ||
        (!widget.all && expenseListViewmodel.expensesToday.isEmpty)) {
      return const WidgetEmpty(
        subtitle: 'No expenses available yet',
      );
    }

    return WidgetExpenseListWithoutFilter(
      expenses: widget.all
          ? expenseListViewmodel.expensesAll
          : expenseListViewmodel.expensesToday,
      canScroll: widget.canScroll,
      onDissmissed: (expense) {
        return dismissExpense(expense);
      },
    );
  }
}
