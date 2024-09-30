import 'dart:async';
import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/expense_list/expense_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListViewmodel extends StateNotifier<ExpenseListState> {
  final ExpenseRepository<Expense> expenseRepository;
  final ReceiptRepository<Receipt> receiptRepository;
  StreamSubscription<List<Expense>>? _allExpenseSubscription;
  StreamSubscription<List<Expense>>? _todayExpenseSubscription;

  ExpenseListViewmodel(
      {required this.expenseRepository, required this.receiptRepository})
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
    await expense.receipts.load();
    for (final receipt in expense.receipts) {
      await receiptRepository.deletObject(receipt);
    }

    await expenseRepository.deletObject(expense);
  }

  Future<void> deleteAll() async {
    await Future.wait([
      expenseRepository.clearData(),
      receiptRepository.clearGallery(),
    ]);
  }

  void resetExpenseFilter() {
    state = state.copyWith(expensesFilter: []);
  }

  void filterByCategory(CategoryEnum value) async {
    await expenseRepository.getObjectsByCategory(value).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByAmountRange(double low, double high) async {
    await expenseRepository.getObjectsByAmountRange(low, high).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByAmountGreaterThan(double amount) async {
    await expenseRepository
        .getObjectsWithAmountGreaterThan(amount)
        .then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByAmountLessThan(double amount) async {
    await expenseRepository.getObjectsWithAmountLessThan(amount).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByAmountAndCategory(
      CategoryEnum value, double amountHighValue) async {
    await expenseRepository
        .getObjectsByOptions(value, amountHighValue)
        .then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByNotOthersCategory() async {
    await expenseRepository.getObjectsNotOthersCategory().then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByGroupFilter(String searchText, DateTime dateTime) async {
    log('$searchText ${dateTime.toString()}');
    await expenseRepository
        .getObjectsByGroupFilter(searchText, dateTime)
        .then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByPaymentMethod(String searchText) async {
    await expenseRepository.getObjectsBySearchText(searchText).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByUsingAny(List<CategoryEnum> categories) async {
    await expenseRepository.getObjectsUsingAnyOf(categories).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByUsingAll(List<CategoryEnum> categories) async {
    await expenseRepository.getObjectsUsingAllOf(categories).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterbyTags(int tags) async {
    await expenseRepository.getObjectsWithTags(tags).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByTagName(String tagName) async {
    await expenseRepository.getObjectsWithTagName(tagName).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterBySubCategory(String subCategory) async {
    await expenseRepository.getObjectsBySubCategory(subCategory).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByReceipt(String receiptName) async {
    await expenseRepository.getObjectsByReceipts(receiptName).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByPagination(int offset) async {
    await expenseRepository.getObjectsAndPaginate(offset).then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByFindingFirst() async {
    await expenseRepository.getOnlyFirstObject().then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  void filterByDeletingFirst() async {
    await expenseRepository.deleteOnlyFirstObject().then((value) {
      state = state.copyWith(expensesFilter: value);
    });
  }

  @override
  void dispose() {
    _allExpenseSubscription?.cancel();
    _todayExpenseSubscription?.cancel();

    super.dispose();
  }
}
