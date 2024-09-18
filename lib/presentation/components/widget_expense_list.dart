import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_without_filter.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetExpenseList extends ConsumerStatefulWidget {
  final bool filter;
  final bool all;
  final bool canScroll;

  const WidgetExpenseList({
    super.key,
    required this.filter,
    required this.all,
    this.canScroll = false,
  });

  @override
  ConsumerState<WidgetExpenseList> createState() => _WidgetExpenseListState();
}

class _WidgetExpenseListState extends ConsumerState<WidgetExpenseList> {
  @override
  void initState() {
    super.initState();
    //TODO pindahin ke viewmodel lain
    final homeViewModel = ref.read(homeViewmodelProvider.notifier);

    if (!widget.filter) {
      if (widget.all) {
        homeViewModel.getAllExpense();
      } else {
        homeViewModel.getTodayExpense();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filter) {
      return const WidgetExpenseListWithFilter();
    }

    final homeState = ref.watch(homeViewmodelProvider);

    if (widget.all) {
      if (homeState.expensesAll.isEmpty) {
        return const WidgetEmpty(
          subtitle: 'No expenses available yet',
        );
      }
    } else {
      if (homeState.expensesToday.isEmpty) {
        return const WidgetEmpty(
          subtitle: 'No expenses available yet',
        );
      }
    }

    return WidgetExpenseListWithoutFilter(
      expenses: widget.all ? homeState.expensesAll : homeState.expensesToday,
      canScroll: widget.canScroll,
    );
  }
}
