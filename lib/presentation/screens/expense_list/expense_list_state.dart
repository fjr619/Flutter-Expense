// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/expense.dart';

class ExpenseListState {
  final List<Expense> expensesToday;
  final List<Expense> expensesAll;

  ExpenseListState({
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
  })  : expensesToday = expensesToday ?? [],
        expensesAll = expensesAll ?? [];

  ExpenseListState copyWith({
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
  }) {
    return ExpenseListState(
      expensesToday: expensesToday ?? this.expensesToday,
      expensesAll: expensesAll ?? this.expensesAll,
    );
  }
}
