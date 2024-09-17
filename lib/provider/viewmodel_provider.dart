import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_state.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_viewmodel.dart';
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

final expenseViewmodelProvider =
    StateNotifierProvider<ExpenseViewmodel, ExpenseState>((ref) {
  final ReceiptRepository<Receipt> receiptRepository =
      ref.watch(receiptRepositoryProvider);
  final ExpenseRepository<Expense> expenseRepository =
      ref.watch(expenseRepositoryProvider);
  return ExpenseViewmodel(
    receiptRepository: receiptRepository,
    expenseRepository: expenseRepository,
  );
});

final detailViewModelProvider =
    StateNotifierProvider.autoDispose<DetailViewmodel, DetailState>(
  (ref) {
    final ExpenseRepository<Expense> expenseRepository =
        ref.watch(expenseRepositoryProvider);
    return DetailViewmodel(expenseRepository: expenseRepository);
  },
);
