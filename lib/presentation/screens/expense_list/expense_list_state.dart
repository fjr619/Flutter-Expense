// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/util/util.dart';

class ExpenseListState {
  final List<Expense> expensesToday;
  final List<Expense> expensesAll;
  final List<Expense> expensesFilter;
  final Filterby? filterby;

  ExpenseListState({
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
    List<Expense>? expensesFilter,
    this.filterby,
  })  : expensesToday = expensesToday ?? [],
        expensesAll = expensesAll ?? [],
        expensesFilter = expensesFilter ?? [];

  ExpenseListState copyWith({
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
    Filterby? filterby,
    List<Expense>? expensesFilter,
  }) {
    return ExpenseListState(
        expensesToday: expensesToday ?? this.expensesToday,
        expensesAll: expensesAll ?? this.expensesAll,
        filterby: filterby ?? this.filterby,
        expensesFilter: expensesFilter ?? this.expensesFilter);
  }
}
