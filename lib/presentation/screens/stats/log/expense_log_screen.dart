import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseLogScreenKeyProvider =
    Provider((ref) => GlobalKey<_ExpenseLogScreenState>());

class ExpenseLogScreen extends ConsumerStatefulWidget {
  const ExpenseLogScreen({super.key});

  @override
  ConsumerState<ExpenseLogScreen> createState() => _ExpenseLogScreenState();
}

class _ExpenseLogScreenState extends ConsumerState<ExpenseLogScreen> {
  late final expenseLogVM = ref.read(expenseLogViewModelProvider.notifier);
  String test = '';

  void update(String value) {
    setState(() {
      test = value;
    });
  }

  void loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      expenseLogVM.loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    log('init _ExpenseLogScreenState');
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final logState = ref.watch(expenseLogViewModelProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  //TODO
                },
                icon: const Icon(
                  Icons.tune,
                  color: Colors.teal,
                )),
          ),
          Text(
            '${logState.countExpense} items',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: WidgetExpenseList(
              filter: false,
              all: true,
              canScroll: true,
            ),
          ))
        ],
      ),
    );
  }
}
