import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/header.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    log('percent ${homeState.percent}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: ListView(
        children: [
          Header(
            percent: homeState.percent,
            totalValue: homeState.totalValue,
            budgetValue: homeState.budgetValue,
            submitBudget: (amount) {
              submitBudget(ref, amount);
            },
          ),
        ],
      ),
    );
  }
}
