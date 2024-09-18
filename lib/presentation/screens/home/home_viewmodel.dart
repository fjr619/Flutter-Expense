import 'dart:async';
import 'dart:developer';

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
  StreamSubscription<List<Expense>>? _allExpenseSubscription;
  StreamSubscription<List<Expense>>? _todayExpenseSubscription;

  HomeViewmodel({
    required this.budgetRepository,
    required this.expenseRepository,
  }) : super(HomeState()) {
    getBudget();
    // getExpenseTotal();
  }

  @override
  void dispose() {
    _budgetSubscription?.cancel();
    _allExpenseSubscription?.cancel();
    _todayExpenseSubscription?.cancel();
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
        log('budget ${state.budget?.amount}');
      },
    );
  }

  void getAllExpense() {
    _allExpenseSubscription?.cancel();
    _allExpenseSubscription = expenseRepository.getAllObjects().listen(
      (expenses) {
        // state = state.copyWith(expenses: expenses);
      },
    );
  }

  void getTodayExpense() {
    _todayExpenseSubscription?.cancel();
    _todayExpenseSubscription = expenseRepository.getObjectsByToday().listen(
      (expenses) async {
        await getExpenseTotal();
        state = state.copyWith(expenses: expenses);
      },
    );
  }

  Future<void> getExpenseTotal() async {
    final expense = await expenseRepository.totalExpenses();
    state = state.copyWith(totalValue: expense);
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
