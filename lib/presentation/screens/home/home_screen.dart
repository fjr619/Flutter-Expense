import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_date.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list.dart';
import 'package:flutter_expensetracker/presentation/components/widget_header.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> submitBudget(WidgetRef ref, double amount) async {
    final viewModel = ref.read(homeViewmodelProvider.notifier);
    await viewModel.submitBudget(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch the homeState
    final homeState = ref.watch(homeViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        actions: [
          (homeState.isLoading)
              ? const CircularProgressIndicator(color: Colors.teal)
              : IconButton(onPressed: () {}, icon: const Icon(Icons.sync)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            WidgetHeader(
              percent: homeState.percent,
              totalValue: homeState.totalValue,
              budgetValue: homeState.budgetValue,
              hasBudget: (homeState.budget != null) ? true : false,
              submitBudget: (amount) {
                submitBudget(ref, amount);
              },
            ),
            const WidgetTitle(title: 'Expenses', clr: Colors.black),
            WidgetExpenseDate(
                date: DateFormat.d().format(DateTime.now()),
                day: DateFormat.EEEE().format(DateTime.now())),
            const WidgetExpenseList(
              filter: false,
              all: false,
            ),
          ],
        ),
      ),
    );
  }
}
