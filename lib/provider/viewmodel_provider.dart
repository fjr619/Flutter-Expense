import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_state.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_viewmodel.dart';
import 'package:flutter_expensetracker/provider/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewmodelProvider = StateNotifierProvider<HomeViewmodel, HomeState>(
  (ref) {
    final BudgetRepository<Budget> budgetRepository =
        ref.watch(budgetRepositoryProvider);
    final ExpenseRepository<Expense> expenseRepository =
        ref.watch(expenseRepositoryProvider);
    return HomeViewmodel(
      budgetRepository: budgetRepository,
      expenseRepository: expenseRepository,
    );
  },
);
