import 'dart:async';

import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewmodel extends StateNotifier<HomeState> {
  final BudgetRepository<Budget> budgetRepository;
  final ExpenseRepository<Expense> expenseRepository;

  StreamSubscription<Budget?>? _budgetSubscription;
  StreamSubscription<double>? _totalExpenseSubscription;

  HomeViewmodel({
    required this.budgetRepository,
    required this.expenseRepository,
  }) : super(HomeState()) {
    getBudget();
  }

  @override
  void dispose() {
    _budgetSubscription?.cancel();
    _totalExpenseSubscription?.cancel();
    super.dispose();
  }

  void getBudget({int? month, int? year}) {
    month ??= DateTime.now().month;
    year ??= DateTime.now().year;

    _budgetSubscription?.cancel();

    _budgetSubscription =
        budgetRepository.getObjectByDate(month: month, year: year).listen(
      (budget) {
        state = state.copyWith(budget: budget);
      },
    );

    _totalExpenseSubscription?.cancel();
    _totalExpenseSubscription = expenseRepository.totalExpenses().listen(
      (total) {
        state = state.copyWith(totalValue: total);
      },
    );
  }

  Future<void> submitBudget(double amount) async {
    if (state.budget == null) {
      final budget = Budget()
        ..month = DateTime.now().month
        ..year = DateTime.now().year
        ..amount = amount;

      return await budgetRepository.createObject(budget);
    } else {
      state.budget!.amount = amount;
      return await budgetRepository.updateObject(state.budget!);
    }
  }
}
