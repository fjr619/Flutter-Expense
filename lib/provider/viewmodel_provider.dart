import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/expense_list/expense_list_state.dart';
import 'package:flutter_expensetracker/presentation/screens/expense_list/expense_list_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_state.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/gallery/gallery_state.dart';
import 'package:flutter_expensetracker/presentation/screens/gallery/gallery_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_state.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/general/general_state.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/general/general_viewmodel.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/log/expense_log_state.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/log/expense_log_viewmodel.dart';
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

final expenseListViewmodelProvider =
    StateNotifierProvider<ExpenseListViewmodel, ExpenseListState>(
  (ref) {
    final receiptRepository = ref.watch(receiptRepositoryProvider);
    final expenseRepository = ref.watch(expenseRepositoryProvider);
    return ExpenseListViewmodel(
        expenseRepository: expenseRepository,
        receiptRepository: receiptRepository);
  },
);

final expenseViewmodelProvider =
    StateNotifierProvider.autoDispose<ExpenseViewmodel, ExpenseState>((ref) {
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

final generalViewModelProvider =
    StateNotifierProvider<GeneralViewmodel, GeneralState>(
  (ref) {
    final BudgetRepository<Budget> budgetRepository =
        ref.watch(budgetRepositoryProvider);
    final ExpenseRepository<Expense> expenseRepository =
        ref.watch(expenseRepositoryProvider);
    return GeneralViewmodel(
        expenseRepository: expenseRepository,
        budgetRepository: budgetRepository);
  },
);

final expenseLogViewModelProvider =
    StateNotifierProvider<ExpenseLogViewmodel, ExpenseLogState>(
  (ref) {
    final ExpenseRepository<Expense> expenseRepository =
        ref.watch(expenseRepositoryProvider);
    return ExpenseLogViewmodel(expenseRepository: expenseRepository);
  },
);

final galleryViewModelProvider =
    StateNotifierProvider<GalleryViewmodel, GalleryState>(
  (ref) {
    final ReceiptRepository<Receipt> receiptRepository =
        ref.watch(receiptRepositoryProvider);
    return GalleryViewmodel(receiptRepository: receiptRepository);
  },
);
