// Define the BudgetRepository provider
import 'package:flutter_expensetracker/data/repositories/budget_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/expense_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/income_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/receipt_repository_impl.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/income_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final isar = ref.watch(isarProvider).maybeWhen(
        data: (isarInstance) => isarInstance,
        orElse: () => null,
      );

  if (isar != null) {
    return BudgetRepositoryImpl(isar);
  } else {
    throw Exception('Isar instance not available');
  }
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final isar = ref.watch(isarProvider).maybeWhen(
        data: (isarInstance) => isarInstance,
        orElse: () => null,
      );

  if (isar != null) {
    return ExpenseRepositoryImpl(isar);
  } else {
    throw Exception('Isar instance not available');
  }
});

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  final isar = ref.watch(isarProvider).maybeWhen(
        data: (isarInstance) => isarInstance,
        orElse: () => null,
      );

  if (isar != null) {
    return IncomeRepositoryImpl(isar);
  } else {
    throw Exception('Isar instance not available');
  }
});

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  final isar = ref.watch(isarProvider).maybeWhen(
        data: (isarInstance) => isarInstance,
        orElse: () => null,
      );

  if (isar != null) {
    return ReceiptRepositoryImpl(isar);
  } else {
    throw Exception('Isar instance not available');
  }
});
