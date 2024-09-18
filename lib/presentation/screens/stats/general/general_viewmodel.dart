import 'dart:async';
import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/general/general_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralViewmodel extends StateNotifier<GeneralState> {
  final ExpenseRepository<Expense> expenseRepository;
  final BudgetRepository<Budget> budgetRepository;

  StreamSubscription<Budget?>? _budgetSubscription;

  GeneralViewmodel(
      {required this.expenseRepository, required this.budgetRepository})
      : super(GeneralState()) {
    loadData();
  }

  void loadData() async {
    _budgetSubscription?.cancel();

    _budgetSubscription = budgetRepository
        .getObjectByDate(month: DateTime.now().month, year: DateTime.now().year)
        .listen(
      (budget) {
        state = state.copyWith(budgetValue: budget != null ? budget.amount : 0);
      },
    );

    await Future.delayed(const Duration(seconds: 1));
  }
}
