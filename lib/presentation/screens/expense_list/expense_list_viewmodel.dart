import 'dart:async';

import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/expense_list/expense_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListViewmodel extends StateNotifier<ExpenseListState> {
  final ExpenseRepository<Expense> expenseRepository;
  StreamSubscription<List<Expense>>? _allExpenseSubscription;
  StreamSubscription<List<Expense>>? _todayExpenseSubscription;

  ExpenseListViewmodel({required this.expenseRepository})
      : super(ExpenseListState());

  void getAllExpense() {
    _allExpenseSubscription?.cancel();
    _allExpenseSubscription = expenseRepository.getAllObjects().listen(
      (expenses) {
        state = state.copyWith(expensesAll: expenses);
      },
    );
  }

  void getTodayExpense() {
    _todayExpenseSubscription?.cancel();
    _todayExpenseSubscription = expenseRepository.getObjectsByToday().listen(
      (expenses) async {
        state = state.copyWith(expensesToday: expenses);
      },
    );
  }

  Future<void> deleteExpense(Expense expense) async {
    await expenseRepository.deletObject(expense);
  }

  @override
  void dispose() {
    _allExpenseSubscription?.cancel();
    _todayExpenseSubscription?.cancel();

    super.dispose();
  }
}
