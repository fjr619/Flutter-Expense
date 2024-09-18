import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_without_filter.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  final bool filter;
  final bool all;
  final bool canScroll;

  const ExpenseListScreen({
    super.key,
    required this.filter,
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

    if (!widget.filter) {
      if (widget.all) {
        exepsneListVM.getAllExpense();
      } else {
        exepsneListVM.getTodayExpense();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filter) {
      return const WidgetExpenseListWithFilter();
    }

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
    );
  }
}
