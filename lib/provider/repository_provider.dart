// Define the BudgetRepository provider
import 'package:flutter_expensetracker/data/repositories/budget_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/expense_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/income_repository_impl.dart';
import 'package:flutter_expensetracker/data/repositories/receipt_repository_impl.dart';
import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/income.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/budget_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/income_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final budgetRepositoryProvider = Provider<BudgetRepository<Budget>>((ref) {
  final Isar isar = ref.watch(isarProvider);
  return BudgetRepositoryImpl(isar);
});

final expenseRepositoryProvider = Provider<ExpenseRepository<Expense>>((ref) {
  final Isar isar = ref.watch(isarProvider);
  return ExpenseRepositoryImpl(isar);
});

final incomeRepositoryProvider = Provider<IncomeRepository<Income>>((ref) {
  final Isar isar = ref.watch(isarProvider);
  return IncomeRepositoryImpl(isar);
});

final receiptRepositoryProvider = Provider<ReceiptRepository<Receipt>>((ref) {
  final Isar isar = ref.watch(isarProvider);
  return ReceiptRepositoryImpl(isar);
});
