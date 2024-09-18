import 'dart:async';
import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/general/general_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class GeneralViewmodel extends StateNotifier<GeneralState> {
  final ExpenseRepository<Expense> expenseRepository;
  final BudgetRepository<Budget> budgetRepository;

  StreamSubscription<Budget?>? _budgetSubscription;
  StreamSubscription<MapEntry<CategoryEnum, double>>? _catSumSubscription;

  GeneralViewmodel(
      {required this.expenseRepository, required this.budgetRepository})
      : super(GeneralState()) {
    log('init');
    loadData();
  }

  void loadData() async {
    // Cancel any existing subscriptions to avoid memory leaks
    _budgetSubscription?.cancel();
    _catSumSubscription?.cancel();

    // Subscribe to budget updates
    _budgetSubscription = budgetRepository
        .getObjectByDate(month: DateTime.now().month, year: DateTime.now().year)
        .listen((budget) {
      state = state.copyWith(budgetValue: budget != null ? budget.amount : 0);
    });

    // Set up a list to hold the category sums
    List<double> categorySums = List.filled(CategoryEnum.values.length, 0.0);

    // Create a list of streams for each category
    final List<Stream<MapEntry<CategoryEnum, double>>> categoryStreams =
        CategoryEnum.values.map((category) {
      return expenseRepository
          .getSumForCategory(category)
          .map((sum) => MapEntry(category, sum));
    }).toList();

    // Merge all category streams into a single stream using rxdart's Stream.merge()
    _catSumSubscription = Rx.merge(categoryStreams).listen((entry) {
      // Extract the category and the sum from the entry
      final category = entry.key;
      final sum = entry.value;

      log('category $category');
      log('sum $sum');

      // Find the index of the category and update the category sum in the list
      final categoryIndex = CategoryEnum.values.indexOf(category);
      categorySums[categoryIndex] = sum;

      // Update the state with the new category sums
      state = state.copyWith(categorySum: categorySums);
    });

    await Future.delayed(const Duration(seconds: 1)); // Optional delay
  }
}
