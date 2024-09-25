import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/detail/detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailViewmodel extends StateNotifier<DetailState> {
  final ExpenseRepository<Expense> expenseRepository;

  DetailViewmodel({
    required this.expenseRepository,
  }) : super(DetailState(expense: null)) {
    log('== init detail vm');
  }

  Future<void> loadExpenseById(String id, Function() finishLoad) async {
    Expense? expense = await expenseRepository.getObjectById(int.parse(id));
    state = state.copyWith(expense: expense);
    finishLoad();
  }
}
