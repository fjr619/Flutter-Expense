import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/log/expense_log_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseLogViewmodel extends StateNotifier<ExpenseLogState> {
  final ExpenseRepository<Expense> expenseRepository;

  ExpenseLogViewmodel({required this.expenseRepository})
      : super(ExpenseLogState());

  void loadData() async {
    final count = await expenseRepository.getTotalObjects();
    state = state.copyWith(countExpense: count);
  }
}
