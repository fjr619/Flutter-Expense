import 'dart:async';

import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/log/expense_log_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseLogViewmodel extends StateNotifier<ExpenseLogState> {
  final ExpenseRepository<Expense> expenseRepository;
  StreamSubscription<int>? _countExpenseSubscription;

  ExpenseLogViewmodel({required this.expenseRepository})
      : super(ExpenseLogState());

  void loadData() async {
    _countExpenseSubscription?.cancel();

    _countExpenseSubscription = expenseRepository.getTotalObjects().listen(
      (count) {
        state = state.copyWith(countExpense: count);
      },
    );
  }

  @override
  void dispose() {
    _countExpenseSubscription?.cancel();
    super.dispose();
  }
}
