import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchViewmodel extends StateNotifier<List<Expense>> {
  final ExpenseRepository<Expense> expenseRepository;

  SearchViewmodel({
    required this.expenseRepository,
  }) : super(List.empty());

  Future<void> filterByFullTextSearch(String searchText) async {
    log('search $searchText');
    if (searchText.isEmpty) {
      state = [];
      return;
    }
    state = await expenseRepository.fullTextSearch(searchText);
    log("state ${state.length}");
  }
}
